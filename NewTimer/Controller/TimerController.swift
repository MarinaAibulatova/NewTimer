//
//  TimerController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 27.01.2021.
//

import Foundation
import UIKit

class TimerController: UIViewController {
    
    private var result: AnyObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        result =  timer.objectWillChange.sink {self.updateLabel()}
        
        workTimeText.delegate = self
        restTimeText.delegate = self
        roundsCountText.delegate = self
    }
    
    var timer = TimerCrossfit()
   
    @IBOutlet weak var timerState: UILabel!
    @IBOutlet weak var timerTime: UILabel!
    @IBOutlet weak var timerRounds: UILabel!
    
    @IBOutlet weak var workTimeText: UITextField!
    @IBOutlet weak var restTimeText: UITextField!
    @IBOutlet weak var roundsCountText: UITextField!
    
    @IBAction func startTimer(_ sender: UIButton) {
        
        if !checkEmptyFields() {
            timer.start(workTime: workTimeText.text!, restTime: restTimeText.text! , roundsCount: roundsCountText.text!)
        }
    }
    
    @IBAction func pauseTimer(_ sender: UIButton) {
        timer.pause()
    }
    
    
    @IBAction func stopTimer(_ sender: UIButton) {
        timer.resetTimer()
    }
   
    func updateLabel(){
        timerState.text     = timer.currentState
        timerTime.text      = timer.time
        timerRounds.text    = String(timer.currentRound)
    }
    
    func checkEmptyFields() -> Bool {
        var fieldIsEmpty: Bool = false
        if let workTime = workTimeText.text {
            if workTime.isEmpty {
                fieldIsEmpty = true
                showAlertEmptyField(field: workTimeText.restorationIdentifier!)
            }
            if Int(workTime) ?? 0 > 60 {
                showAlertLimit(field: workTimeText.restorationIdentifier!)
            }
        }
        if let restTime = restTimeText.text {
            if restTime.isEmpty {
                fieldIsEmpty = true
                showAlertEmptyField(field: restTimeText.restorationIdentifier!)
            }
        }
        if let roundsCount = roundsCountText.text {
            if roundsCount.isEmpty {
                fieldIsEmpty = true
                showAlertEmptyField(field: roundsCountText.restorationIdentifier!)
            }
        }
        return fieldIsEmpty
    }
    
    func showAlertEmptyField(field: String){
        let alert = UIAlertController(title: "\(field) is empty", message: "Please, fill the field", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertLimit(field: String){
        let alert = UIAlertController(title: "\(field) time can't be more 60", message: "Please, enter new value", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension TimerController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For numers
        if textField == workTimeText {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if let restorationIdentifier = textField.restorationIdentifier {
                if restorationIdentifier.hasPrefix(Constans.work) {
                    restTimeText.text = String(60 - (text as NSString).integerValue)
                }else if restorationIdentifier.hasPrefix(Constans.work) {
                    workTimeText.text = String(60 - (text as NSString).integerValue)
                }
            }
            
        }
    }
}


