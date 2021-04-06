//
//  TableExercisesViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 04.03.2021.
//

import Foundation
import UIKit

class TableExercisesViewController: UITableViewController, ItemDetailViewControllerDelegate {

    
//    var row0Item = ChecklistItems()
//    var row1Item = ChecklistItems()
//    var row2Item = ChecklistItems()
    
    var items = [ChecklistItems]()
    var checklist: Checklist!
    override func viewDidLoad() {
        super.viewDidLoad()
        let row0Item = ChecklistItems()
        row0Item.text = "walk"
        
        items.append(row0Item)
        navigationItem.largeTitleDisplayMode = .never
        
        loadItems()
        title = checklist.name
        
        print("doc folder \(documetDirectory())")
        print("file path \(dataFilePath())")
        
    }
    //MARK: - Safe/Load data
    func documetDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }

    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            
        } catch {
            print(error)
        }
    }
    func loadItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([ChecklistItems].self, from: data)
            }catch {
                print(error)
            }
        }
    }
    func dataFilePath() -> URL {
        return documetDirectory().appendingPathComponent("List.plist")
    }
    //MARK: - Exercise Delegates
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishing item: ChecklistItems) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        saveItems()
        
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItems) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        saveItems()
        navigationController?.popViewController(animated: true)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        }else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                print(indexPath)
                print(indexPath.row)
                controller.itemToEdit = items[indexPath.row]
            }
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
            print(indexPath.row)
            let item = items[indexPath.row]
            item.checked.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveItems()
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItems) {
       // var isChecked = false
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            //cell.accessoryType = .checkmark
            label.text = "√"
        }else {
            //cell.accessoryType = .none
            label.text = ""
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
