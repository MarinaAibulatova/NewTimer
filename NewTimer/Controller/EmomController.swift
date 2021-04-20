//
//  EmomController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 04.03.2021.
//

import Foundation
import UIKit

class EmomController: UIViewController, WorkoutsListViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var timerState: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseWorkout" {
            let controllerN = segue.destination as! UINavigationController
            let controller = controllerN.topViewController as! WorkoutsListViewController
            controller.delegate = self
        }
    }
    
    //MARK: - WorkoutListViewControllerDelegate
    func endChouseWorkout(_ controller: WorkoutsListViewController, _ workout: Workout) {
        print(workout.name)
        timerState.text = workout.name
        title = workout.name
    }
}
