//
//  ExercisesController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 19.04.2021.
//

import Foundation
import UIKit

class ExercisesController: UIViewController, ExerciseManagerDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseManager.delegate = self
        labelWorkout.text = "Workouts:"
    }
    
    var exerciseManager = ExerciseManager()
    var workouts = [WorkoutOfTheDay]()
    
    @IBOutlet weak var labelWorkout: UILabel!
    
    @IBAction func showExercises(_ sender: Any) {
        exerciseManager.receiveWorkoutsList()
        print("w count = \(workouts.count)")
    }
    
    //MARK: - Exercise Manager Delegate
    func didFinishGettingWorkout(workout: [Workout]) {
//        DispatchQueue.main.async {
//            self.labelWorkout.text = self.labelWorkout.text! + "\(workout.day_list)"
//        }
    }
    
    func didFinishCreateWorkout(workout: Workout) {
        
    }
}
