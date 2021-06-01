//
//  JSONParser.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 01.06.2021.
//

import Foundation

struct JSONParser {
    var data: Data
    let decoder: JSONDecoder
    
    init(data: Data) {
        self.data = data
        self.decoder = JSONDecoder()
    }
    
    func getWorkoutsList() -> WorkoutsList? {
        do {
            let decoderData = try decoder.decode(WorkoutsList.self, from: data)
            let count = decoderData.count
            let results = decoderData.results

            let workoutsList = WorkoutsList(count: count, results: results)
            return workoutsList
        }catch {
            return nil
        }
    }
    
    func getWorkoutOfTheDay() -> WorkoutOfTheDay? {
        do {
            let decoderData = try decoder.decode(WorkoutOfTheDay.self, from: data)
            let obj = decoderData.obj
            let dayList = decoderData.day_list
            
            let workoutOfDay = WorkoutOfTheDay(obj: obj, day_list: dayList)
            
            return workoutOfDay
        } catch {
            print(error)
            return nil
        }
    }
    
    func getSettingId() -> Int? {
        do {
            let decoderData = try decoder.decode(Setting.self, from: data)
            
            return decoderData.id
        } catch {
            print(error)
            return nil
        }
    }
}
