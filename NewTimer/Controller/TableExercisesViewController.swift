//
//  TableExercisesViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 04.03.2021.
//

import Foundation
import UIKit

class TableExercisesViewController: UITableViewController, ExerciseViewControllerDelegate {

    
    var row0Item = ChecklistItems()
    var row1Item = ChecklistItems()
    var row2Item = ChecklistItems()
    
    var items = [ChecklistItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let row0Item = ChecklistItems()
        row0Item.text = "walk"
        
        items.append(row0Item)
        
        let row1Item = ChecklistItems()
        row1Item.text = "eat"
        
        items.append(row1Item)
        
        let row2Item = ChecklistItems()
        row2Item.text = "sleep"
        
        items.append(row2Item)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    //MARK: - Exercise Delegates
    
    func addExerciseViewControllerDidCancel(_ controller: ExersiceViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addExerciseViewController(_ controller: ExersiceViewController, didFinishing item: ChecklistItems) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ExersiceViewController
            controller.delegate = self
        }
    }
    
    //MARK: - Table View Data Sourse
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Items", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItems) {
       // var isChecked = false
        
        if item.checked {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItems) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
//        var textField = UITextField()
//
//        let elert = UIAlertController(title: "Add new complex", message: "", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
//
//
//
//        }
//
        let newRowIndex = items.count
        
        let item = ChecklistItems()
        item.text = "new"
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }
}
