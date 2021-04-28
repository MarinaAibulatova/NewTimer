//
//  WorkoutsList.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 28.04.2021.
//

import Foundation

struct WorkoutsList {
    let count: Int
    let rezults: [WorkoutsRezult]
}

struct WorkoutsRezult {
    let id: Int
    var creationDate: String
        // подумать над форматом даты
//        let dateFormatter = ISO8601DateFormatter()
//        let date = dateFormatter.date(from: self.creationDate)!
//
//        return dateFormatter.string(from: date)
        
    
    
}
