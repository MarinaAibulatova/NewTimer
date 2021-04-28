//
//  AuthViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 21.04.2021.
//

import UIKit
import Foundation

class AuthViewController: UIViewController, AuthManagerDelegate, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        authManager.delegate = self
        
        loginText.delegate = self
        passwordText.delegate = self
        loginText.becomeFirstResponder()
 
    }
   var authManager = AuthManager()
    

    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signInButtonPressed(_ sender: Any) {
         let username = "MarinaAibulatova"
         let password = "@QUGv%59A#@zx$Cl1e$y"
        
       // let username = loginText.text!
       // let password = passwordText.text!
        errorText.text = ""
        authManager.auth(username: username, password: password)
        
        
        //        //get workouts
        //        let userName = "marinka-dgerry@yandex.ru"
        //        let password = "@QUGv%59A#@zx$Cl1e$y"
        
        //        let token = "Token 6a7f55dab50dbdd0feb2c9fa5a764c488786157f"
        //        let loginString = "\(userName):\(password)"
        //
        //        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
        //            return
        //        }
//        let base64LoginString = loginData.base64EncodedString()
//
//        let url = URL(string: urlAuth)!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        do {
//            request.setValue(token, forHTTPHeaderField: "Authorization")
//
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: request) { (data, responce, error) in
//                print(error)
//
//                if let safeData = data {
//                    let responseString = String(data: safeData, encoding: .utf8)
//                    print("raw response: \(responseString)")
//                }
//            }
//            task.resume()
//        } catch {
//            print(error)
//        }
       
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showMenu", errorText.text == nil {
            return false
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMenu" {
          
        }
    }
    
    func didFailWithError(error: String, from: Int) {
        DispatchQueue.main.async {
            self.errorText.text = error
        }
    }
    func didFinishAuth() {
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordText.becomeFirstResponder()
    }

}
