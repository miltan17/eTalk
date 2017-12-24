//
//  ViewController.swift
//  eTalk
//
//  Created by Miltan on 12/24/17.
//  Copyright © 2017 Milton. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var textTextField: UITextField!
    
    var synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func talkButtonClicked(_ sender: UIButton) {
        if textTextField.text != nil {
            if let text = textTextField.text{
                let utterance = AVSpeechUtterance(string: text)
                utterance.rate = 0.5
                synthesizer.speak(utterance)
                
            }
        }
    }
}

