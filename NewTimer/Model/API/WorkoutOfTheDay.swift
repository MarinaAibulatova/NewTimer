//
//  WorkoutAPIStructure.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 28.04.2021.
//

import Foundation

struct WorkoutOfTheDay: Codable {
    let obj: DescriptionOfObject
    var day_list: [DayList]
}

struct DayList: Codable {
    var obj: DescriptionOfObject
    var set_list: [SetList]
    
}

struct DescriptionOfObject: Codable {
    let id: Int?
    let description: String?
    let name: String?
}

struct SetList: Codable {
    var exercise_list: [ExerciseList]
}

struct ExerciseList: Codable {
    var obj: DescriptionOfObject
    var setting_text: String
}
