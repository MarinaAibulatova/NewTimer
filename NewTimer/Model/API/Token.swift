//
//  Token.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 29.04.2021.
//

import Foundation

struct Token: Codable {
    var token: String
    static var tokenKey: String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "tokenKey") as? String
    }
}
