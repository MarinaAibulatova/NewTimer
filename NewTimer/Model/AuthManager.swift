//
//  AuthManager.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 22.04.2021.
//

import Foundation

protocol AuthManagerDelegate {
    func didFailWithError(error: String)
    func didFinishAuth()
}

struct AuthManager {
    
    //MARK: - Variables
    var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }()
    
    var delegate: AuthManagerDelegate?
    var hasMistake: Bool = false
    
    //MARK: - Authorization
     func auth(username: String, password: String) {
        let parameters: [String: Any] = ["username": username, "password": password]
        let urlLogin = URL(string: Constans.urlAuth)!
        
        var request = URLRequest(url: urlLogin)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            delegate?.didFailWithError(error: Constans.errorMessage)
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                delegate?.didFailWithError(error: Constans.errorMessage)
                return
            }
            
            if let httpsResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpsResponse.statusCode) {
                    if let safeData = data {
                       let decoder = JSONDecoder()
                        do{
                            let token = try decoder.decode(Token.self, from: safeData)
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(token.token, forKey: "tokenKey")
                        } catch {
                            delegate?.didFailWithError(error: Constans.errorMessage)
                        }
                    }
                } else {
                    var errorMessage: String = ""
                    switch httpsResponse.statusCode {
                    case 401:
                        errorMessage = Constans.errorAuthMessage
                    default:
                        errorMessage = Constans.errorMessage
                    }
                    delegate?.didFailWithError(error: errorMessage)
                }
            }
        }
        task.resume()
     }
}

//401 - неправильный логин/пароль
//400 - неверный запрос
//404 - запрос не найден

