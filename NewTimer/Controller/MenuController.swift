//
//  ViewController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 26.01.2021.
//

import UIKit

class MenuController: UIViewController {
   
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timerButton.layer.cornerRadius      = Constans.radiusButton
        emomButton.layer.cornerRadius       = Constans.radiusButton
        exercisesButton.layer.cornerRadius  = Constans.radiusButton
        aboutButton.layer.cornerRadius      = Constans.radiusButton
        
    }
    
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var emomButton: UIButton!
    @IBOutlet weak var exercisesButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
}

