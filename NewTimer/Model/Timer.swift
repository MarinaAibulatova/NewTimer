//
//  Timer.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 01.02.2021.
//

import Foundation
import UIKit

class TimerCrossfit: ObservableObject {
    var time: String = "00:00:00"
    var currentRound: Int = 0
    var currentState: String = "work"
    
    var timeSec: Int = 0
    
    var timer = Timer()
    
    func start(workTime: String, restTime: String, roundsCount: String) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block:
        { (timer) in
            self.timerUpdate(workTime: workTime, restTime: restTime, roundsCount: roundsCount)
        })
    }
    
    func pause(){
        timer.invalidate()
    }
    
    func timerUpdate(workTime: String, restTime: String, roundsCount: String) {
        let workTimeInt     = Int(workTime)!
        let restTimeInt     = Int(restTime)!
        let roundsCountInt  = Int(roundsCount)!
        
        let timeRound = workTimeInt + restTimeInt
        
        let timeCurrentRound = timeSec % timeRound
        currentRound = Int(timeSec / timeRound) + 1
        
        // workTime = 20 restTime = 40 timeRound = 60 59 % 60 = 59
        
        if currentRound > roundsCountInt {
            //sound stop
            //time stop
        }
        if timeCurrentRound < workTimeInt {
            if timeCurrentRound == 0 {
                //sound start
            }
            //показать таймер
            currentState = "work"
        }else {
            if (timeCurrentRound - workTimeInt) == 0 {
                //sound start
            }
            //показать таймер
            currentState = "rest"
        }
        
        timeSec += 1
       
    }
}
