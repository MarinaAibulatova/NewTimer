//
//  ExerciseManager.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 19.04.2021.
//

import Foundation

protocol ExerciseManagerDelegate: class {
    func didFinishGettingWorkout(workout: WorkoutOfTheDay)
}

struct ExerciseManager {
    
    var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()
    
    weak var delegate: ExerciseManagerDelegate?
   
    //MARK: - Workouts list
    func receiveWorkoutsList(){
        let url = URL(string: Constans.urlWorkoutsList)!
        var workoutOfTheDayArray = [WorkoutOfTheDay]()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
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
        var workoutOfTheDayArray = [WorkoutOfTheDay]()
        for result in workoutsList.results {
            let id  = result.id
            let urlString = Constans.urlWorkout.replacingOccurrences(of: "id", with: String(id))
            
            let url = URL(string: urlString)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            if let token = Token.tokenKey {
                request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                if let httpsResponse = response as? HTTPURLResponse {
                    if let safeData = data {
                        let workoutOfTheDay = self.parseJSONAPI(safeData) // workoutList
                        if workoutOfTheDay != nil {
                            self.delegate?.didFinishGettingWorkout(workout: workoutOfTheDay!)
                        }
                    }
                }
            }
            task.resume()
        }
        print("count is \(workoutOfTheDayArray.count)")
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
