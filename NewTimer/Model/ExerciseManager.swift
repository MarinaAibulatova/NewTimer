//
//  ExerciseManager.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 19.04.2021.
//

import Foundation

protocol ExerciseManagerDelegate: class {
    func didFinishGettingWorkout(workout: [Workout])
}

struct ExerciseManager {
    
    var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()
    
    weak var delegate: ExerciseManagerDelegate?
   
    func postWorkout(nameOfWorkout: String) {
        let url = URL(string: Constans.urlWorkoutsList)!
        let paremeters: [String: Any] = ["name": nameOfWorkout, "creation_date": "2021-04-28", "description": ""]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: paremeters, options: .prettyPrinted)
        } catch {
            print(error)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error)
            }
            print("ok")
        }
        task.resume()
        
    }
    
    
    //MARK: - Create request
    func createGetRequest(urlString: String) -> URLRequest {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    func createPostRequest(urlString: String, parameters: [String: Any]) -> URLRequest {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let newItem = Setting(set: parameters["set"] as! Int, exercise: parameters["exercise"] as! Int)
        
        do {
            //request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = try JSONEncoder().encode(newItem)
        }catch{
            print(error)
        }
        
        return request
    }
    
    
    func postExercise(parametersToPost: [String: Any], settingIdCompletionHandler: @escaping (Int?, Error?) -> Void) {
       
        let requestSetting = createPostRequest(urlString: Constans.urlSetting, parameters: parametersToPost)
        
        let task = session.dataTask(with: requestSetting) { (data, response, error) in
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
    
    //MARK: - Workouts list
    func receiveWorkoutsList(){
        
        let request = createGetRequest(urlString: Constans.urlWorkoutsList)
        
        let task = session.dataTask(with: request) { (data, response, error) in
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
        
        for result in workoutsList.results {
            group.enter()
            
            let id  = result.id
            let urlString = Constans.urlWorkout.replacingOccurrences(of: "id", with: String(id))
            
            let request = createGetRequest(urlString: urlString)
            
            let task = session.dataTask(with: request) { (data, response, error) in
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
                
                var descriptionOfExercise           = exercise.obj.description!.replacingOccurrences(of: "<p>", with: "")
                descriptionOfExercise               = descriptionOfExercise.replacingOccurrences(of: "</p>", with: "")
                newExercise.descriptionOfExercise   = descriptionOfExercise
                
                newExercise.reps = exercise.setting_text
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
