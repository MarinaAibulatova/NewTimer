//
//  Constans.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 10.02.2021.
//

import Foundation
import UIKit

struct Constans {
    //MARK: - UI components
    static let work: String = "work"
    static let rest: String = "rest"
    static let colorButton = UIColor(red: 241, green: 196, blue: 15, alpha: 1)
    static let radiusButton: CGFloat = 10
    static let dataPath: String = "Workouts.plist"
    //MARK: - API components/ Authorization
    static let urlAuth: String = "https://wger.de/api/v2/login/"
    static let errorAuthMessage = "You have entered an invalid username or password"
    static let errorMessage = "Oops something went wrong :( Please contact your administrator."
    //MARK: - API components/ Workouts
    static let urlWorkoutsList = "https://wger.de/api/v2/workout/"
    static let urlWorkout = "https://wger.de/api/v2/workout/id/canonical_representation/"
    //MARK: - API components/pictures
    static let urlImage = "https://wger.de"
    //MARK: - API search exercises
    static let urlSearchExercises = "https://wger.de/api/v2/exercise/search/?term=searchParameter"
    
    
    

    
    
}
