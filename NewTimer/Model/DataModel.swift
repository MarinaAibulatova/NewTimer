//
//  DataModel.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 12.04.2021.
//

import Foundation
import UIKit

protocol DataModelDelegate: class {
    func didFinishCreateWorkout(workout: Workout)
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
        
        
//        let path = dataFilePuth()
//        if let data = try? Data(contentsOf: path) {
//            let decoder = PropertyListDecoder()
//            do {
//                workouts = try decoder.decode([Workout].self, from: data)
//                sortWorkouts()
//            }catch {
//                print(error)
//            }
//        }
    }
    
    func didFinishGettingWorkout(workout: WorkoutOfTheDay) {
       // print(workout)
        var exercises = [Exercise]()
       
        for dayList in workout.day_list {
            if let name = dayList.obj.description {
                let newWorkout = Workout(nameOfWorkout: name)
            
                for setList in dayList.set_list {
                    for exercise in setList.exercise_list {
                        let newExercise = Exercise()
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
                        exercises.append(newExercise)
                    }
                }
                newWorkout.exercises = exercises
                workouts.append(newWorkout)
                delegate?.didFinishCreateWorkout(workout: newWorkout)
            }
            exercises.removeAll()
        }
        
    }
}
