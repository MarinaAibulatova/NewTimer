//
//  AddComplexViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 23.03.2021.
//

import Foundation
import UIKit

class AddComplexViewController: UITableViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameOfComplex.delegate = self
    }
    
    //MARK: - Outlets
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var nameOfComplex: UITextField!
    
    weak var delegate: AddComplexViewControllerDelegate?
    
    //MARK: - Text Field Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = nameOfComplex.text!
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
        let newComplex = Complex()
        newComplex.name = nameOfComplex.text!
        delegate?.addComplexViewController(controller: self, item: newComplex)
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addComplexViewControllerDidCancel(controller: self)
    }
}

protocol AddComplexViewControllerDelegate: class {
    func addComplexViewControllerDidCancel(controller: AddComplexViewController)
    func addComplexViewController(controller: AddComplexViewController, item: Complex)
}
