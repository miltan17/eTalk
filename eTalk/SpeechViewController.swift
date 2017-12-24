//
//  ViewController.swift
//  eTalk
//
//  Created by Miltan on 12/24/17.
//  Copyright © 2017 Milton. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechViewController: UIViewController {

    @IBOutlet weak var textTextField: UITextField!
    @IBOutlet weak var buttonView: UIView!
    
    var voices = [String: String]()
    var synthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance!
    var button: LSPlayPauseButton!
    
    var rate: Float = 0.5
    var multiplier: Float = 3.5
    var volume: Float = 0.1
    var language: String = "en_UK"
    
    //MARK: - view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton()
        getVoices()
        
        
        let tabBarControllers = self.tabBarController?.viewControllers
        let settingsViewController = tabBarControllers?[1] as! SettingsViewController
        settingsViewController.voices = self.voices
    }
    
    
    
    func createButton() {
        button = LSPlayPauseButton(frame: CGRect(x: 0, y: 0, width: buttonView.layer.bounds.width, height: buttonView.layer.bounds.height), style: .youku, state: .pause)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        buttonView.addSubview(button)
    }
    
    
    
    func getVoices() {
        let locale = NSLocale(localeIdentifier: "en_US")
        
        let identifiers = getIdentifiers()
        for identifier in identifiers {
            let name = locale.displayName(forKey: NSLocale.Key.identifier, value: identifier)!
            voices[identifier] = name
        }
    }
    
    
    func getIdentifiers() -> [String]{
        var voiceList = [String]()
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for voice in voices {
            voiceList.append(voice.language)
        }
        return voiceList
    }
    
    
    //MARK: - Read Text
    
    func tap() {
        button.buttonState = .play
        read()
        
    }
    
    
    func read(){
        if textTextField.text != "" {
            if let text = textTextField.text{
                readText(text)
            }
        }else{
            let text = "Sorry, There is no text to read"
            readText(text)
        }
        
    }
    
    
    func readText(_ text: String){
        speechUtterance = AVSpeechUtterance(string: text)
        
        speechUtterance.rate = rate
        speechUtterance.pitchMultiplier = multiplier
        speechUtterance.volume = volume
        speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
        synthesizer.speak(speechUtterance)

    }
    
}

