//
//  RequestManager.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 03.06.2021.
//

import Foundation

struct RequestManager {
    let urlString: String
    var request: URLRequest
    let url: URL
    
    init(urlString: String) {
        self.urlString = urlString
        self.url = URL(string: self.urlString)!
        self.request = URLRequest(url: self.url)
        
        self.request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    mutating func createGetRequest() -> URLRequest {
        request.httpMethod = "GET"
      
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    mutating func createPatchRequest(parameters: [String: Any]) -> URLRequest {
     
        request.httpMethod = "PATCH"
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }catch{
            print(error)
        }
        
        return request
    }
    
    
    mutating func createWorkoutPostRequest(parameters: [String: Any]) -> URLRequest {
        
        request.httpMethod = "POST"
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }

        let httpBodyItem = WorkoutList(name: parameters["name"] as! String, date: parameters["date"] as! String)
        
        do {
            request.httpBody = try JSONEncoder().encode(httpBodyItem)
        }catch{
            print(error)
        }
        
        return request
    }
    
    mutating func createDayPostRequest(parameters: [String: Any]) -> URLRequest {
        
        request.httpMethod = "POST"
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }

       let httpBodyItem = Day(training: parameters["training"] as! Int, description: parameters["description"] as! String)
        
        do {
           request.httpBody = try JSONEncoder().encode(httpBodyItem)
        }catch{
            print(error)
        }
        
        return request
    }
    
    mutating func createSetPostRequest(parameters: [String: Any]) -> URLRequest {
        request.httpMethod = "POST"
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let httpBodyItem = Set(dayId: parameters["exerciseDay"] as! Int)
        
        do {
            request.httpBody = try JSONEncoder().encode(httpBodyItem)
        }catch {
            print(error)
        }
        
        return request
    }
    
    mutating func createSettingPostRequest(parameters: [String: Any]) -> URLRequest {
        
        request.httpMethod = "POST"
        
        if let token = Token.tokenKey {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }

        let httpBodyItem = Setting(set: parameters["set"] as! Int, exercise: parameters["exercise"] as! Int)
        
        do {
            request.httpBody = try JSONEncoder().encode(httpBodyItem)
        }catch{
            print(error)
        }
        
        return request
    }
}
