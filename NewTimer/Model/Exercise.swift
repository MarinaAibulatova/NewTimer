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
    var reps: String = ""
    var comment: String = ""
    var imageURL: String?
    var wgerData: ExerciseWger?
    var id: Int?
}
