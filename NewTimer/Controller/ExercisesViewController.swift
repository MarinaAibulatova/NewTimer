//
//  ExercisesViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 23.03.2021.
//

import Foundation
import UIKit

class ExercisesViewController: UITableViewController, AddExerciseViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var item = Exercise()
        item.name = "new"
        items.append(item)
        loadData()
        
        if let workout = workout {
            title = workout.name
        }
    }
    
    var items = [Exercise]()
    var workout: Workout?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddСomplex" {
            let controller = segue.destination as! AddExerciseViewController
            controller.delegate = self
        }else if segue.identifier == "EditExercise" {
            let controller = segue.destination as! AddExerciseViewController
            controller.delegate = self
            if  let indexPath = tableView.indexPath(for: (sender as! UITableViewCell)) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    //MARK: - Save/Load data
    
    func documentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask )
        return path[0]
    }
    
    func dataFilePuth() -> URL {
        return documentDirectory().appendingPathComponent("List.plist")
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try? encoder.encode(items)
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
                items = try decoder.decode([Exercise].self, from: data)
            }catch {
                print(error)
            }
        }
        
    }
    
    //MARK: - Add Exercise Delegate
    func addExerciseViewControllerDidCancel(controller: AddExerciseViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addExerciseViewController(controller: AddExerciseViewController, item: Exercise) {
        let rowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        saveData()
        navigationController?.popViewController(animated: true)
    }
    
    func addExerciseViewController(controller: AddExerciseViewController, itemToEdit: Exercise) {
        if let index = items.firstIndex(of: itemToEdit) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                let label = cell.viewWithTag(1000) as! UILabel
                label.text = itemToEdit.name
            }
        }
        saveData()
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Table View Data Sourse
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "complexes", for: indexPath)
        let complex = items[indexPath.row]
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = complex.name
        }
       // cell.accessoryType = complex.checked ? .checkmark : .none
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let item = items[indexPath.row]
        item.checked.toggle()
        saveData()
       // cell?.accessoryType = item.checked ? .checkmark : .none
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveData()
    }
    
}
