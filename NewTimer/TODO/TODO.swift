//
//  TODO.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 20.04.2021.
//

import Foundation

//TO DO

//1. Read documentation about http
//2. Screen authorization user
//3. Screen my workouts
//  3.1 Create struct to get workouts's data
//  3.2 Create struct to get exercises's data
//  3.3 Add/Edit workout. Add calendar?
//  3.4 Add/Edit exercises in workout
//      3.4.1 Find exercises in database
//  3.5 Send data в wger.de

// Group workouts by category, muscles, equipment?


//branch PostWorkouts
//steps to add Workout
// 1. Create workout - id(back from server), creation_date, name, description
// 2. Create day - id(bask from server), training(workout's id), description, day [1,2,3...]
//3. Create set - id(back from server), exerciseday(search?), sets, order
//4. Create settingList - id(back from server), set(set's id)...


//example
// Workout:
    // id: 266026
    //creation_data: "2021-04-19"
    //name: ""
    //description: ""
// Day:
    // id: 135455
    // training: 266026
    // description: Cindy
    // day: [1,2,3] monday...
// Set:
    // id: 258172,
    // exerciseday: 135455,
    // sets: 1 хз
    // order: 2 номер по порядку?
// SettingList
    // id: 585147,
    // set: 258172,
    // exercise: 354,
    // repetition_unit: 1,
    // reps: 10, повторы
    // weight: null,
    // weight_unit: 1,
    // rir: null,
    // order: 1,
    // comment: ""
