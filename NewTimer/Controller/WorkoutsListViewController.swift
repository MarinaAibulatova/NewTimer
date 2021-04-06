//
//  WorkoutsListViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 05.04.2021.
//

import Foundation
import UIKit

class WorkoutsListViewController: UITableViewController, WorkoutsDetailViewControllerDelegate {
    var workouts = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newWorkout = Workout(nameOfWorkout: "cindy")
        workouts.append(newWorkout)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WorkoutCell")
    }
    
    //MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowExercises" {
            let controller = segue.destination as! ExercisesViewController
            controller.workout = sender as! Workout
            
        }else if segue.identifier == "AddWorkout" {
            let controller = segue.destination as! WorkoutsDetailViewController
            controller.delegate = self
        }
    }
    

    //MARK: - Table data sourse
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        workouts.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell")!
        let workout = workouts[indexPath.row]
        cell.textLabel?.text = workout.name
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = workouts[indexPath.row]
        performSegue(withIdentifier: "ShowExercises", sender: workout)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(identifier: "WorkoutsDetailViewController") as! WorkoutsDetailViewController
        controller.delegate = self
        
        let workout = workouts[indexPath.row]
        controller.workoutToEdit = workout
        
        navigationController?.pushViewController(controller, animated: true)
    }

    //MARK: - Workouts View Controller Delegate
    func workoutsDetailViewControllerDidCancel(_ controller: WorkoutsDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func workoutsDetailViewController(_ controller: WorkoutsDetailViewController, didFinishAdding workout: Workout) {
        let newIndex = workouts.count
        workouts.append(workout)
        
        let indexPath = IndexPath(row: newIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func workoutsDetailViewController(_ controller: WorkoutsDetailViewController, didFinishEditing workout: Workout) {
        if let index = workouts.firstIndex(of: workout) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = workout.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    

    
}
