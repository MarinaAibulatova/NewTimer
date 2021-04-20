//
//  Workout.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 05.04.2021.
//

import Foundation

class Workout: NSObject, Codable {
    var name: String
    var exercises = [Exercise]()
    init(nameOfWorkout name: String) {
        self.name = name
    }
}
