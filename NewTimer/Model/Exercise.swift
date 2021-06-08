//
//  Exercise.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 24.03.2021.
//

import Foundation

class Exercise: NSObject, Codable {
    var name: String = ""
    var descriptionOfExercise: String = ""
    var reps: Int = 0
    var comment: String = ""
    var imageURL: String?
    var wgerData: ExerciseWger?
    var id: Int?
    var settingId: Int?
}
