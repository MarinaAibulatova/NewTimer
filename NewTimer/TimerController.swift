//
//  TimerController.swift
//  NewTimer
//
//  Created by Марина Айбулатова on 27.01.2021.
//

import Foundation
import UIKit

class TimerController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        timerState.text = "Check"
    }
    
    @IBOutlet weak var timerState: UILabel!
    
}
