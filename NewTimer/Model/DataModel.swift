//
//  DataModel.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 12.04.2021.
//

import Foundation
import UIKit

protocol DataModelDelegate: class {
    func didFinishCreateWorkout(workout: [Workout])
}

class DataModel: ExerciseManagerDelegate {
    
    var workouts = [Workout]()
    var exerciseManager = ExerciseManager()
    weak var delegate: DataModelDelegate?
    
    init() {
        exerciseManager.delegate = self
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
      exerciseManager.receiveWorkoutsList()
    }
    
    func didFinishGettingWorkout(workout: [Workout]) {
        self.workouts = workout
        delegate?.didFinishCreateWorkout(workout: workout)
    }
    
    func didFinishCreateWorkout(workout: Workout) {
        
    }
}
