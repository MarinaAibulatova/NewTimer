//
//  SearchManager.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 20.05.2021.
//

import Foundation

protocol SearchManagerDelegate: class {
    func didFinishSearchExercises(searchResults: [SearchResult])
    func didFinishCreateExercise(exercise: Exercise)
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
                    self.parseJSON(data: safeData)
                    //delegate?.didFinishSearchExercises(exercises: exercisesArray)
                }
            }
            
        }
        
        task.resume()
        
        
    }
    
    func parseJSON(data: Data) {
        
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(SearchResultsOfExercises.self, from: data)
            print(decoderData)
            //esxercise array
            delegate?.didFinishSearchExercises(searchResults: decoderData.suggestions)
         
        } catch {
            print(error)
        }
    }
    
    func createExercise(searchResult: SearchResult) {
        let myURL = Constans.urlExerciseInfo.replacingOccurrences(of: "id", with: String(searchResult.data.id))
        
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
                    self.parseJSONExercise(data: safeData)
                    //delegate?.didFinishSearchExercises(exercises: exercisesArray)
                }
            }
        }
        task.resume()
        
    }
    
    func parseJSONExercise(data: Data) {
        
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(ExerciseWger.self, from: data)
            print(decoderData)
            //esxercise
            var newExercise = Exercise()
            newExercise.name = decoderData.name
            newExercise.id = decoderData.id
            newExercise.descriptionOfExercise = decoderData.description
            
            for image in decoderData.images {
                if image.is_main {
                    newExercise.imageURL = image.image
                    break
                }
            }
            
            delegate?.didFinishCreateExercise(exercise: newExercise)
         
        } catch {
            print(error)
        }
    }
}
