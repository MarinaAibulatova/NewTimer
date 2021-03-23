//
//  ExerciseViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 17.03.2021.
//

import Foundation
import UIKit

class ExersiceViewController: UITableViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        complex.becomeFirstResponder()
    }
    
    weak var delegate: ExerciseViewControllerDelegate?
    
    @IBOutlet weak var complex: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK: - Text Field Delegate
    //To Do: - check work doneBarButton

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = complex.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    //MARK: - Actions

    @IBAction func cancel(_ sender: Any) {
        delegate?.addExerciseViewControllerDidCancel(self)
        //navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func done(_ sender: Any) {
        let item = ChecklistItems()
        item.text = complex.text!
        delegate?.addExerciseViewController(self, didFinishing: item)
       // navigationController?.popViewController(animated: true)
    }
}
protocol ExerciseViewControllerDelegate: class {
    func addExerciseViewControllerDidCancel(_ controller: ExersiceViewController)
    func addExerciseViewController(_ controller: ExersiceViewController, didFinishing item: ChecklistItems)
}
