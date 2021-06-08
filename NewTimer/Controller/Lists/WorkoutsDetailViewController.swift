//
//  WorkoutsDetailViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 05.04.2021.
//

import Foundation
import UIKit


protocol WorkoutsDetailViewControllerDelegate: class {
    func workoutsDetailViewControllerDidCancel(_ controller: WorkoutsDetailViewController)
    func workoutsDetailViewController(_ controller: WorkoutsDetailViewController, didFinishAdding workout: Workout)
    func workoutsDetailViewController(_ controller: WorkoutsDetailViewController, didFinishEditing workout: Workout)
}

class WorkoutsDetailViewController: UITableViewController, UITextFieldDelegate, ExerciseManagerDelegate {
    
    var workoutToEdit: Workout?
    weak var delegate: WorkoutsDetailViewControllerDelegate?
    var exerciseManager = ExerciseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let workout = workoutToEdit {
            title = "Edit"
            nameOfWorkoutTextField.text = workout.name
            doneBarButton.isEnabled = true
        }
        exerciseManager.delegate = self
    }
    
    @IBOutlet weak var nameOfWorkoutTextField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //MARK: - Actions

    @IBAction func done(_ sender: Any) {
       // exerciseManager.postExercise()
        if let workout = workoutToEdit {
            workout.name = nameOfWorkoutTextField.text!
            delegate?.workoutsDetailViewController(self, didFinishEditing: workout)
        } else {
            //add workout to wger.de
            exerciseManager.postWorkout(nameOfWorkout: nameOfWorkoutTextField.text!)
           // let newWorkout = Workout(nameOfWorkout: nameOfWorkoutTextField.text!)
           // delegate?.workoutsDetailViewController(self, didFinishAdding: newWorkout)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.workoutsDetailViewControllerDidCancel(self)
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    
    //MARK: - Text Field Felegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    //MARK: - Exercise Manager Delegate
    
    func didFinishGettingWorkout(workout: [Workout]) {
        
    }
    
    func didFinishCreateWorkout(workout: Workout) {
        delegate?.workoutsDetailViewController(self, didFinishAdding: workout)
    }

}
