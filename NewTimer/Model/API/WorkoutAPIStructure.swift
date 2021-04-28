//
//  WorkoutAPIStructure.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 28.04.2021.
//

import Foundation

struct WorkoutAPIStructure {
    let id: Int
    var dayList: [Any]
}

struct DayList {
    var obj: Obj
    var setList: [SetList]
    
}

struct Obj {
    let id: Int
    let description: String
    let name: String
}

struct SetList {
    var exerciseList: [ExerciseList]
}

struct ExerciseList {
    var obj: Obj
    var settingText: String
}
