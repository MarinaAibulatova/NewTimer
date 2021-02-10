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
    
    var playerStartRound    = AVAudioPlayer()
    var playerStopRound     = AVAudioPlayer()
    
    var timeSec: Int = 0
    
    var timer = Timer()
    
    func playSound(player: String) {
        //sound file
        if player == "start" {
            let soundStartRound = Bundle.main.path(forResource: "startRound", ofType: "mp3")
            do {
                playerStartRound = try AVAudioPlayer(contentsOf:
                    URL(fileURLWithPath: soundStartRound!))
            }
            catch {
                print(error)
            }
            playerStartRound.play()
        }else {
            let soundStopRound = Bundle.main.path(forResource: "stopTimer", ofType: "mp3")
            do {
                playerStopRound = try AVAudioPlayer(contentsOf:
                    URL(fileURLWithPath: soundStopRound!))
            }
            catch {
                print(error)
            }
            playerStopRound.play()
        }
    }
    
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
            playSound(player: "stop")
            //time stop
            resetTimer()
        } else {
            if timeCurrentRound < workTimeInt {
                if timeCurrentRound == 0 {
                    //sound start
                    playSound(player: "start")
                }
                //показать таймер
                time = showTimer(time: timeCurrentRound)
                currentState = "Work"
            }else {
                if (timeCurrentRound - workTimeInt) == 0 {
                    //sound start
                    playSound(player: "start")
                }
                //показать таймер
                time = showTimer(time: timeCurrentRound - workTimeInt)
                currentState = "Rest"
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
        playSound(player: "stop")
    }
}
