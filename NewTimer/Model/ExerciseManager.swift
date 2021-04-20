//
//  ExerciseManager.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 19.04.2021.
//

import Foundation

struct ExerciseManager {
    
    let exerciseURL = "https://wger.de/api/v2/exercise/?language=2"
    
    func performRequest() {
        if let url = URL(string: exerciseURL) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //to do error func
                }
                
                if let safeData = data {
                    if let exercise = self.parseJSON(safeData) {
                        //to do show exercise
                    }
                }
            }
        }
    }
    
    func parseJSON(_ exerciseData: Data) -> Exercise? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(ExerciseData.self, from: exerciseData)
           // let description = decoderData.description
           // let name = decoderData.name
            
            let exercise = Exercise()
           // exercise.name = description + name
            
            return exercise
        } catch {
            return nil
        }
       
    }
}
