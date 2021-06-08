//
//  ExercisesViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 23.03.2021.
//

import Foundation
import UIKit

class ExercisesViewController: UITableViewController, AddExerciseViewControllerDelegate, SearchExerciseTableViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let workout = workout {
            title = workout.name
        }
    }
    
   // var items = [Exercise]()
    var workout: Workout!
    var exerciseManager: ExerciseManager?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExercise" {
            let controller = segue.destination as! SearchExerciseTableViewController
            controller.delegate = self
        }else if segue.identifier == "EditExercise" {
            let controller = segue.destination as! AddExerciseViewController
            controller.delegate = self
            if  let indexPath = tableView.indexPath(for: (sender as! UITableViewCell)) {
                controller.itemToEdit = workout.exercises[indexPath.row]
            }
        }
    }
    
    //MARK: - Add Exercise Delegate
    func addExerciseViewControllerDidCancel(controller: AddExerciseViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addExerciseViewController(controller: AddExerciseViewController, item: Exercise) {
        let rowIndex = workout.exercises.count
        workout.exercises.append(item)
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func addExerciseViewController(controller: AddExerciseViewController, itemToEdit: Exercise) {
        if let index = workout.exercises.firstIndex(of: itemToEdit) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                let label = cell.viewWithTag(1000) as! UILabel
                label.text = itemToEdit.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Table View Data Sourse
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercises", for: indexPath)
        let complex = workout.exercises[indexPath.row]
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = complex.name
        }
    
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let item = workout.exercises[indexPath.row]
 
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        workout.exercises.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
      
    }
    
    //MARK: - SearchExerciseTableViewControllerDelegate
    
    func didFinishChooseExercise(exercise: Exercise) {
        workout.exercises.append(exercise)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        exerciseManager = ExerciseManager()
        let postExercise: [String: Any] = ["set": workout.setId, "exercise": exercise.id]
        //exerciseManager?.postExercise(parametersToPost: postExercise)
       
        exerciseManager?.postExercise(parametersToPost: postExercise, settingIdCompletionHandler: { (settingId, error) in
            
            if let settindId = settingId {
                exercise.settingId = settingId
            }
        })
        
        // add exercise to wger.de
       // exerciseManager = ExerciseManager()
        
    }
    
}
