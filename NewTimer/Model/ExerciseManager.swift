//
//  ExerciseManager.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 19.04.2021.
//

import Foundation

protocol ExerciseManagerDelegate: class {
    func didFinishGettingWorkout(workout: [Workout])
    func didFinishCreateWorkout(workout: Workout)
}

struct ExerciseManager {
    
    var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()
    
    weak var delegate: ExerciseManagerDelegate?
   
    func postWorkout(nameOfWorkout: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: Date())
        
        let workoutListParameters: [String: Any] = ["name": nameOfWorkout, "date": currentDate]
        var requestManager = RequestManager(urlString: Constans.urlWorkoutsList)
        let postWorkoutRequest = requestManager.createWorkoutPostRequest(parameters: workoutListParameters)
        
        let task = session.dataTask(with: postWorkoutRequest) { (data, responce, error) in
            if error != nil {
                print(error)
            }
            
            if let _ = responce as? HTTPURLResponse {
                if let safeData = data {
                    let jsonParser = JSONParser(data: safeData)
                    let workoutList  = jsonParser.getWorkoutList()
                    if let _ = workoutList {
                        self.postDay(workoutList: workoutList!)
                    }
                }
            }
            
        }
        task.resume()
    }
    
    func postDay(workoutList: WorkoutList) {
        let dayParameters: [String: Any] = ["training": workoutList.id, "description": workoutList.name]
        var requestManager = RequestManager(urlString: Constans.urlDay)
        let postDayRequest = requestManager.createDayPostRequest(parameters: dayParameters)
        
        let task = session.dataTask(with: postDayRequest) { (data, responce, error) in
            if error != nil {
                print(error)
            }
            
            if let _ = responce as? HTTPURLResponse {
                if let safeData = data {
                    let jsonParser = JSONParser(data: safeData)
                    let day = jsonParser.getDay()
                    if let _ = day {
                        self.postSet(day: day!)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func postSet(day: Day) {
        let setParameters: [String: Any] = ["exerciseDay": day.id]
        var requestManager = RequestManager(urlString: Constans.urlSet)
        let postSetRequest = requestManager.createSetPostRequest(parameters: setParameters)
        
        let task = session.dataTask(with: postSetRequest) { (data, responce, error) in
            if error != nil {
                print(error)
            }
            
            if let _ = responce as? HTTPURLResponse {
                if let safeData = data {
                    let jsonParser = JSONParser(data: safeData)
                    let set = jsonParser.getSet()
                    let newWorkout = Workout(nameOfWorkout: day.description)
                    newWorkout.dayId = day.id
                    newWorkout.setId = set?.id
                   
                    delegate?.didFinishCreateWorkout(workout: newWorkout)
                }
            }
        }
        
        task.resume()
    }
    
    //MARK: - Exercise: add/update
    
    func postExercise(parametersToPost: [String: Any], settingIdCompletionHandler: @escaping (Int?, Error?) -> Void) {
       
        var requestManager = RequestManager(urlString: Constans.urlSetting)
        let postRequest = requestManager.createSettingPostRequest(parameters: parametersToPost)
        
        let task = session.dataTask(with: postRequest) { (data, response, error) in
            if error != nil {
                print(error)
            }
            
            if let _ = response as? HTTPURLResponse {
                do {
                    //update setting id in exercise
                    if let safeData = data {
                        let jsonParser = JSONParser(data: safeData)
                        let settingId = jsonParser.getSettingId()
                        
                        settingIdCompletionHandler(settingId, nil)
                        
                    }
                }catch {
                    print(error)
                    settingIdCompletionHandler(nil, error)
                    
                }
            }
        }
        
        task.resume()
        
    }
    
    func updateExercise(exercise: Exercise) {
        let settingIdString = String(exercise.settingId!)
        let urlString = String("\(Constans.urlSetting)\(settingIdString)/")
        let parameters: [String: Any] = ["reps": exercise.reps] // to:do reps as INT?
        
        var requestManager = RequestManager(urlString: urlString)
        let patchRequest = requestManager.createPatchRequest(parameters: parameters)
        
        let task = session.dataTask(with: patchRequest) { (data, responce, error) in
            if error != nil {
                return
            }
            
            print(responce)
        }
        
        task.resume()
    }
    
    //MARK: - Workouts list
    func receiveWorkoutsList(){
        var requestManager = RequestManager(urlString: Constans.urlWorkoutsList)
        let getRequest = requestManager.createGetRequest()
        
        let task = session.dataTask(with: getRequest) { (data, response, error) in
            if error != nil {
                return
            }
            
            if let httpsResponse = response as? HTTPURLResponse {
                if let safeData = data {
                    
                    let jsonParser = JSONParser(data: safeData)
                    let workoutsList = jsonParser.getWorkoutsList()
                 
                    if let list = workoutsList {
                        self.performRequestWorkouts(list)
                    }else {
                        
                    }
                }
            }
        }
        task.resume()
    }
    
    func performRequestWorkouts(_ workoutsList: WorkoutsList) {
        var workouts = [Workout]()
        let group = DispatchGroup()
        //to: do error in count of workouts!!!
        for result in workoutsList.results {
            group.enter()
            
            let id  = result.id
            let urlString = Constans.urlWorkout.replacingOccurrences(of: "id", with: String(id))
            
            var requestManager = RequestManager(urlString: urlString)
            let getRequest = requestManager.createGetRequest()
            
            let task = session.dataTask(with: getRequest) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                if let httpsResponse = response as? HTTPURLResponse {
                    if let safeData = data {
                        
                        let jsonParser = JSONParser(data: safeData)
                        let workoutOfTheDay = jsonParser.getWorkoutOfTheDay()
                
                        if workoutOfTheDay != nil {
                            workouts = createWorkouts(workoutOfTheDay: workoutOfTheDay!)
                            group.leave()
                        }
                    }
                }
            }
            task.resume()
        }
        
        let didFinishCreateWorkouts = DispatchWorkItem {
            self.delegate?.didFinishGettingWorkout(workout: workouts)
        }
        
        group.notify(queue: .main, work: didFinishCreateWorkouts)
      
    }
    
    func createWorkouts(workoutOfTheDay: WorkoutOfTheDay) -> [Workout] {
        
        var workoutsArray = [Workout]()
        for dayList in workoutOfTheDay.day_list {
            
            let day = dayList.obj
            var newWorkout = Workout(nameOfWorkout: day.description)
            newWorkout.dayId = day.id
            
            var exerciseListArray: [ExerciseList] = []
            
            for setList in dayList.set_list {
                if newWorkout.setId == nil {
                    newWorkout.setId = setList.obj.id
                }
                exerciseListArray += setList.exercise_list
            }
            
            for exercise in exerciseListArray {
                let newExercise = Exercise()
                newExercise.id = exercise.obj.id
                newExercise.name = exercise.obj.name!
                newExercise.settingId = exercise.setting_obj_list[0].id
                newExercise.reps = exercise.setting_obj_list[0].reps
                
                var descriptionOfExercise           = exercise.obj.description!.replacingOccurrences(of: "<p>", with: "")
                descriptionOfExercise               = descriptionOfExercise.replacingOccurrences(of: "</p>", with: "")
                newExercise.descriptionOfExercise   = descriptionOfExercise
                
                if exercise.comment_list.count > 0 {
                    newExercise.comment = exercise.comment_list[0]
                }
                
                for image in exercise.image_list {
                    if image.is_main {
                        newExercise.imageURL = image.image
                        break
                    }
                }
                newWorkout.exercises.append(newExercise)
            }
            workoutsArray.append(newWorkout)
        }
        return workoutsArray
    }
    
    
}
