//
//  WorkoutsList.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 28.04.2021.
//

import Foundation

struct WorkoutsList: Codable {
    let count: Int
    let results: [WorkoutsResult]
}

struct WorkoutsResult: Codable {
    let id: Int
    var creation_date: String
        // подумать над форматом даты
//        let dateFormatter = ISO8601DateFormatter()
//        let date = dateFormatter.date(from: self.creationDate)!
//
//        return dateFormatter.string(from: date)
        
    
    
}
