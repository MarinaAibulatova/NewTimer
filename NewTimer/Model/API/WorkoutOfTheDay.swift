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
    var obj: Day
    var set_list: [SetList]
    
}

struct DescriptionOfObject: Codable {
    let id: Int
    let description: String?
    let name: String?
}

struct SetList: Codable {
    let obj: Set
    var exercise_list: [ExerciseList]
}

struct ExerciseList: Codable {
    var setting_obj_list: [Setting]
    var obj: DescriptionOfObject
    var setting_text: String
    var comment_list: [String]
    var image_list: [Image]
}

struct Image: Codable {
    var image: String
    var is_main: Bool
}

//search exercises

struct SearchResultsOfExercises: Codable {
    var suggestions: [SearchResult]
}

struct SearchResult: Codable {
    var value: String
    var data: SearchData
}

struct SearchData: Codable {
    var id: Int
}

struct ExerciseWger: Codable {
    var id: Int
    var name: String
    var description: String
    var images: [Image]
}

// API
struct WorkoutList: Codable {
    let id: Int?
    let creation_date: String
    let name: String
    let desription: String?
    
    init(name: String, date: String) {
        self.id = nil
        self.creation_date = date
        self.name = name
        self.desription = name
    }
    
    init(id: Int, name: String, date: String) {
        self.id = id
        self.creation_date = date
        self.name = name
        self.desription = name
    }
}

struct DayArray: Codable {
    let results: [Day]
}

struct SetArray: Codable {
    let results: [Set]
}

struct SettingArray: Codable {
    let results: [Setting]
}

struct Day: Codable {
    let id: Int?
    let training: Int // workout id
    let description: String //delete optional
    let day: [Int]
    
    init(training: Int, description: String) {
        self.id = nil
        self.training = training
        self.description = description
        self.day = [1,2]
    }
    
    init(id: Int, training: Int, description: String) {
        self.id = id
        self.training = training
        self.description = description
        self.day = [1,2]
    }
}

struct Set: Codable {
    let id: Int?
    let exerciseday: Int //day id
    let sets: Int
    let order: Int
    
    init(id: Int, dayId: Int) {
        self.id = id
        self.exerciseday = dayId
        self.sets = 1
        self.order = 1
    }
    
    init(dayId: Int) {
        self.id = nil
        self.exerciseday = dayId
        self.sets = 1
        self.order = 1
    }
}

struct Setting: Codable {
    let id: Int?
    let set: Int //set id
    let exercise: Int //exercise id
    let repetition_unit: Int
    let reps: Int
    let weight: String?
    let weight_unit: Int
    let order: Int
    let comment: String
    
    init(set: Int, exercise: Int) {
        self.set = set
        self.exercise = exercise
        self.repetition_unit = 1
        self.weight_unit = 1
        self.reps = 0
        self.order = 1
        self.weight = "1"
        self.comment = ""
        self.id = nil
    }
    
}
