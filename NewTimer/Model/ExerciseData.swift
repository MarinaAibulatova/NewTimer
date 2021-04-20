//
//  ExerciseModel.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 20.04.2021.
//

import Foundation

struct ExerciseData: Codable {
    let name: String
    let description: String
}

struct ExercisesModel: Codable {
    let count: Int
    let next: String
    let results: [ExerciseData]
}
