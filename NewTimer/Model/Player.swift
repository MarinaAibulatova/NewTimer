//
//  Player.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 10.02.2021.
//

import Foundation
import AVFoundation

struct Player {
    var player: AVAudioPlayer
    var sound: String
    
    init(sound: String) {
        self.player = AVAudioPlayer()
        self.sound = sound
    }
    
    mutating func playSound() {
        let soundToPlay = Bundle.main.path(forResource: sound, ofType: "mp3")
        do {
            player = try AVAudioPlayer(contentsOf:
                URL(fileURLWithPath: soundToPlay!))
        }
        catch {
            print(error)
        }
        player.play()
    }
}
