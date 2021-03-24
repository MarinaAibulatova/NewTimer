//
//  MyComplexesViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 23.03.2021.
//

import Foundation
import UIKit

class MyComplexesViewController: UITableViewController, AddComplexViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var items = [Complex()]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add complex" {
            let controller = segue.destination as! AddComplexViewController
            controller.delegate = self
        }
    }
    
    //MARK: - Add Complex Delegate
    func addComplexViewControllerDidCancel(controller: AddComplexViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addComplexViewController(controller: AddComplexViewController, item: Complex) {
        let rowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
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
        cell.accessoryType = complex.checked ? .checkmark : .none
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let item = items[indexPath.row]
        item.checked.toggle()
        cell?.accessoryType = item.checked ? .checkmark : .none
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
}
