//
//  SearchManager.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 20.05.2021.
//

import Foundation

protocol SearchManagerDelegate: class {
    func didFinishSearchExercises(exercises: [Exercise])
}

struct SearchManager {
    
    var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()
    
    weak var delegate: SearchManagerDelegate?
    
    func searchExercises(orderText: String) {
        let myURL = Constans.urlSearchExercises.replacingOccurrences(of: "searchParameter", with: orderText)
        
        guard let url = URL(string: myURL) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue(" application/json", forHTTPHeaderField: "Accept")
        request.setValue(" application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error)
            }
            
            if let httpsResponse = response as? HTTPURLResponse {
                
                if let safeData = data {
                    var exercisesArray = self.parseJSON(data: safeData)
                    delegate?.didFinishSearchExercises(exercises: exercisesArray)
                }
            }
            
        }
        
        task.resume()
        
        
    }
    
    func parseJSON(data: Data) -> [Exercise] {
        var exercisesArray = [Exercise]()
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(SearchResultsOfExercises.self, from: data)
            print(decoderData)
            //esxercise array
            
            for result in decoderData.suggestions {
                let newExerciseWger = ExerciseWger(id: result.data.id, name: result.data.name, image: result.data.image)
                
                var exercise = Exercise()
                exercise.wgerData = newExerciseWger
                exercise.name = result.data.name
                exercisesArray.append(exercise)
            }
            
        } catch {
            print(error)
        }
        return exercisesArray
    }
}
