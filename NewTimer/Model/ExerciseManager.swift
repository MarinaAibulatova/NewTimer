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
    
    func postExercise() {
        let url = URL(string: "https://wger.de/api/v2/day/")
        
        let newStructure: [String: Any] = ["training": 269641, "description": "testNew2", "day": [1,2]]
        
        let parameters: [String: Any] = ["results": newStructure]
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: newStructure, options: .prettyPrinted)
        } catch {
            print(error)
        }
        
        let task = session.dataTask(with: request) {(data, response, error) in
            if error != nil {
                print(error)
            }
            
            do {
                let myData = try JSONSerialization.jsonObject(with: data!, options: []) 
                print("ok")
                
            }catch {
                print(error)
            }
        }
        task.resume()
        
    }
    
    //MARK: - Create request
    func createRequest(urlString: String) -> URLRequest {
        let urlDay = URL(string: urlString)!
        var request = URLRequest(url: urlDay)
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    //MARK: - Workouts list
    
    func receiveWorkoutsListTwo() {
        let requestDay = createRequest(urlString: Constans.urlDay)
        let requestSet = createRequest(urlString: Constans.urlSet)
        let requestSetting = createRequest(urlString: Constans.urlSetting)
        
        let requests = ["DayArray": requestDay, "SetArray": requestSet, "SettingArray": requestSetting]
        var wgerData: [String: Any] = [:]
        
        let group = DispatchGroup()
        var decoderData: Any?
        
        for request in requests {
            group.enter()
            
            let task = session.dataTask(with: request.value) { (data, response, error) in
                if error != nil {
                    print(error)
                }
                
                if let _ = response as? HTTPURLResponse {
                    if let safeData = data {
                        //parseJSON
                        let decoder = JSONDecoder()
                        //var decoderData: Any?
                        do {
                            if request.key == "DayArray" {
                                decoderData = try decoder.decode(DayArray.self, from: safeData)
                            }
                            if request.key == "SetArray" {
                                decoderData = try decoder.decode(SetArray.self, from: safeData)
                            }
                            if request.key == "SettingArray" {
                                decoderData = try decoder.decode(SettingArray.self, from: safeData)
                            }
                            
                            print(request.key)
                            wgerData[request.key] = decoderData
                            
                            group.leave()
                        }catch {
                            print(error)
                        }
                        
                        
                    }
                }
            }
            
            task.resume()
        }
        let item = DispatchWorkItem {
            //create workouts and receive them
            let dayArray = wgerData["DayArray"] as! DayArray
            let setArray = wgerData["SetArray"] as! SetArray
            let settingArray = wgerData["SettingArray"] as! SettingArray
            
            
            
            
            
            
            
            
//            var workouts = [Workout]()
//
//            for day in dayArray.results {
//
//                var newWorkout = Workout(nameOfWorkout: day.description)
//                workouts.append(newWorkout)
//                //id
//
//                //set
//                // if let set = setArray.results.first(where: {$0.exerciseday == day.id}) {
//                let sets = setArray.results.filter({$0.exerciseday == day.id})
//                //setting
//                print(sets)
//                //                    if let setting = settingArray.results.first(where: {$0.set == set.id}) {
//                //                        print(setting.exercise)
//                //                    }
//            }
            
            
        }
        group.notify(queue: .main, work: item)
        // print(wgerData)

    }
    
    func receiveWorkoutsList(){
        
        let request = createRequest(urlString: Constans.urlWorkoutsList)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
            
            if let httpsResponse = response as? HTTPURLResponse {
                if let safeData = data {
                    let workoutsList = self.parseJSON(safeData) // workoutList
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
            
            let request = createRequest(urlString: urlString)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                if let httpsResponse = response as? HTTPURLResponse {
                    if let safeData = data {
                        let workoutOfTheDay = self.parseJSONAPI(safeData) // workoutList
                
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
    
    func parseJSON(_ data: Data) -> WorkoutsList? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(WorkoutsList.self, from: data)
            let count = decoderData.count
            let results = decoderData.results

           let workoutsList = WorkoutsList(count: count, results: results)

            return workoutsList
        } catch {
            return nil
        }

    }
    
    func parseJSONAPI(_ data: Data) -> WorkoutOfTheDay? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(WorkoutOfTheDay.self, from: data)
            let obj = decoderData.obj
            let dayList = decoderData.day_list
            
            let workoutOfDay = WorkoutOfTheDay(obj: obj, day_list: dayList)
            
            return workoutOfDay
        } catch {
            print(error)
            return nil
        }
    }
}
