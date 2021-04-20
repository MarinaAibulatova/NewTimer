//
//  ExercisesController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 19.04.2021.
//

import Foundation
import UIKit

class ExercisesController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var exerciseManager = ExerciseManager()
    
    @IBAction func showExercises(_ sender: Any) {
        performRequest()
    }
    
    
    let exerciseURL = "https://wger.de/api/v2/exercise/?limit=1"
    
    let weatherURL = "https://countriesnow.space/api/v0.1/countries/population/cities"
    
    func performRequest() {
        if let url = URL(string: exerciseURL) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                if let safeData = data {
                    let responseString = String(data: safeData, encoding: .utf8)
                                print("raw response: \(responseString)")
                    if let exercise = self.parseJSON(safeData) {
                        //to do show exercise
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ exerciseData: Data) -> Exercise? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(ExercisesModel.self, from: exerciseData)
            let count = decoderData.count
            let next = decoderData.next
            let results = decoderData.results
            
            let exercise = Exercise()
          //  exercise.name = description + name
            
            return exercise
        } catch {
            return nil
        }
       
    }
}
