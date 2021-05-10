//
//  Exercise.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 24.03.2021.
//

import Foundation

class Exercise: NSObject, Encodable, Decodable {
    var name: String = ""
    var descriptionOfExercise: String = ""
    var reps: String = ""
    var comment: String = ""
}
