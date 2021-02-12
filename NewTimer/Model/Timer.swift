//
//  Timer.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 01.02.2021.
//

import Foundation
import UIKit
import AVFoundation

class TimerCrossfit: ObservableObject {
    @Published var time: String = "00:00:00"
    @Published var currentRound: Int = 0
    @Published var currentState: String = "..."
    
    var playerStartRound    = Player(sound: "startRound")
    var playerStopRound     = Player(sound: "stopTimer")
    
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
        
        if currentRound > roundsCountInt {
            //sound stop
            playerStopRound.playSound()
            //time stop
            resetTimer()
        } else {
            if timeCurrentRound < workTimeInt {
                if timeCurrentRound == 0 {
                    //sound start
                    playerStartRound.playSound()
                }
                //показать таймер
                time = showTimer(time: timeCurrentRound)
                currentState = Constans.work
            }else {
                if (timeCurrentRound - workTimeInt) == 0 {
                    //sound start
                    playerStartRound.playSound()
                }
                //показать таймер
                time = showTimer(time: timeCurrentRound - workTimeInt)
                currentState = Constans.rest
            }
        }
        timeSec += 1
    }
    
    func showTimer(time: Int) -> String {
        let hours, minutes, seconds: Int
        var timeString: [String] = ["00", "00", "00"]
        
        hours   = time / 3600
        minutes = time / 60 % 60
        seconds = time % 60
        
        if hours > 0 {
            timeString[0] = hours < 10 ? ("0\(hours)"): ("\(hours)")
        }
        if minutes > 0 {
            timeString[1] = minutes < 10 ? ("0\(minutes)") : ("\(minutes)")
        }
        if seconds > 0 {
            timeString[2] = seconds < 10 ? ("0\(seconds)") : ("\(seconds)")
        }
        
        return timeString.joined(separator: ":")
    }
    
    func resetTimer() {
        time            = "00:00:00"
        currentRound    = 0
        timeSec         = 0
        currentState    = "..."
        timer.invalidate()
        //sound stop
        playerStopRound.playSound()
    }
}
