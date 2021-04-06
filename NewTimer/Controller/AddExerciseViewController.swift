//
//  AddExerciseViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 23.03.2021.
//

import Foundation
import UIKit

class AddExerciseViewController: UITableViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameOfExercise.delegate = self
        
        if let newItem = itemToEdit {
            nameOfExercise.text = itemToEdit?.name
            title = "Edit complex"
            buttonDone.isEnabled = true
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var nameOfExercise: UITextField!
    
    weak var delegate: AddExerciseViewControllerDelegate?
    var itemToEdit: Exercise?
    
    //MARK: - Text Field Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = nameOfExercise.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        
        print("old text - \(oldText)")
        print(stringRange)
        print("newText - \(newText)")
        buttonDone.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        buttonDone.isEnabled = false
        return true
    }
    
    //MARK: - Actions
    
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit {
            item.name = nameOfExercise.text!
            delegate?.addExerciseViewController(controller: self, itemToEdit: item)
        }else {
            let newExercise = Exercise()
            newExercise.name = nameOfExercise.text!
            delegate?.addExerciseViewController(controller: self, item: newExercise)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addExerciseViewControllerDidCancel(controller: self)
    }
}

protocol AddExerciseViewControllerDelegate: class {
    func addExerciseViewControllerDidCancel(controller: AddExerciseViewController)
    func addExerciseViewController(controller: AddExerciseViewController, item: Exercise)
    func addExerciseViewController(controller: AddExerciseViewController, itemToEdit: Exercise)
}
