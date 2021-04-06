//
//  ExerciseViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 17.03.2021.
//

import Foundation
import UIKit

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit"
            complex.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        complex.becomeFirstResponder()
    }
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItems?
    
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
        delegate?.itemDetailViewControllerDidCancel(self)
        //navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit {
            item.text = complex.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItems()
            item.text = complex.text!
            delegate?.itemDetailViewController(self, didFinishing: item)
        }
       // navigationController?.popViewController(animated: true)
    }
}
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishing item: ChecklistItems)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItems)
}
