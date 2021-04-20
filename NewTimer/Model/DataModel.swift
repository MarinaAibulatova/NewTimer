//
//  DataModel.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 12.04.2021.
//

import Foundation
import UIKit

class DataModel {
    var workouts = [Workout]()
    
    init() {
        loadData()
    }
    
    func sortWorkouts() {
        workouts.sort { (workout1, workout2) -> Bool in
            return workout1.name.compare(workout2.name, options: .caseInsensitive) == .orderedAscending
        }
    }
    
    //MARK: - Save/Load data
    
    func documentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask )
        return path[0]
    }
    
    func dataFilePuth() -> URL {
        return documentDirectory().appendingPathComponent(Constans.dataPath)
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try? encoder.encode(workouts)
            try data?.write(to: dataFilePuth(), options: .atomic)
        }catch {
            print(error)
        }
    }
    
    func loadData() {
        let path = dataFilePuth()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                workouts = try decoder.decode([Workout].self, from: data)
                sortWorkouts()
            }catch {
                print(error)
            }
        }
    }
}
