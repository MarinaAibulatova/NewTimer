//
//  WorkoutsListViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 05.04.2021.
//

import Foundation
import UIKit

protocol WorkoutsListViewControllerDelegate: class {
    func endChouseWorkout(_ controller: WorkoutsListViewController, _ workout: Workout)
}

class WorkoutsListViewController: UITableViewController, WorkoutsDetailViewControllerDelegate, UIGestureRecognizerDelegate {
 
    var dataModel: DataModel!
    var numberOfTaps: Int = 0
    weak var delegate: WorkoutsListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel = DataModel()
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WorkoutCell")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowExercises" {
            let controller = segue.destination as! ExercisesViewController
            controller.workout = sender as? Workout
            
        }else if segue.identifier == "AddWorkout" {
            let controller = segue.destination as! WorkoutsDetailViewController
            controller.delegate = self
        }
        dataModel.saveData()
    }
    
    
    //MARK: - Table data sourse
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.workouts.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        dataModel.workouts.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell")!
        
        let cell: UITableViewCell
        
        if let tmp = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell") {
            cell = tmp
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "WorkoutCell")
        }
        
        let workout = dataModel.workouts[indexPath.row]
        cell.textLabel?.text = workout.name
        cell.accessoryType = .detailDisclosureButton
        
        let countOfExercises = workout.exercises.count
        cell.detailTextLabel?.text = countOfExercises == 0 ? "No exercises" : "\(countOfExercises) exercises"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            
            let controller = self.storyboard?.instantiateViewController(identifier: "WorkoutsDetailViewController") as! WorkoutsDetailViewController
            controller.delegate = self
            
            let workout = self.dataModel.workouts[indexPath.row]
            controller.workoutToEdit = workout
            
            self.navigationController?.pushViewController(controller, animated: true)
            self.dataModel.saveData()
        }
        action.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let workout = dataModel.workouts[indexPath.row]
        delegate?.endChouseWorkout(self, workout)
        dismiss(animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let workout = self.dataModel.workouts[indexPath.row]
        self.performSegue(withIdentifier: "ShowExercises", sender: workout)
    }

    //MARK: - Workouts View Controller Delegate
    func workoutsDetailViewControllerDidCancel(_ controller: WorkoutsDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func workoutsDetailViewController(_ controller: WorkoutsDetailViewController, didFinishAdding workout: Workout) {
        
        dataModel.workouts.append(workout)
        dataModel.sortWorkouts()
        tableView.reloadData()
       
        navigationController?.popViewController(animated: true)
        
    }
    
    func workoutsDetailViewController(_ controller: WorkoutsDetailViewController, didFinishEditing workout: Workout) {
//        if let index = dataModel.workouts.firstIndex(of: workout) {
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) {
//                cell.textLabel?.text = workout.name
//            }
//        }
        dataModel.sortWorkouts()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }

}

