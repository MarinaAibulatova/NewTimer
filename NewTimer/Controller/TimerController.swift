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
    }
    
    var timer = TimerCrossfit()
    var timeString: String = "" {
        didSet {
           // timerState.text = timeString
        }
    }
    @IBOutlet weak var timerState: UILabel!
    @IBOutlet weak var timerTime: UILabel!
    
    @IBAction func startTimer(_ sender: UIButton) {
        timer.start(workTime: "10", restTime: "50", roundsCount: "2")
       // timeString = timer.currentState
    }
    func updateLabel(){
        timerState.text = timer.currentState
        timerTime.text = timer.time
    }
}
