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

    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var buttonView: UIView!
    
    var idByRegion = [String: String]()
    var synthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance!
    var button: LSPlayPauseButton!
    
    
    var speech: Speech!
    
    //MARK: - view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speech = Speech()
        
        createButton()
        getRegions()
        sendVoicesToSettingVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendSpeechToSettingsVC()
    }
    
    
    //MARK: - Fetch Data and Update UI
    
    func createButton() {
        button = LSPlayPauseButton(frame: CGRect(x: 0, y: 0, width: buttonView.layer.bounds.width, height: buttonView.layer.bounds.height), style: .youku, state: .pause)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        buttonView.addSubview(button)
    }
    
    
    func getRegions() {
        let locale = NSLocale(localeIdentifier: "en_US")
        
        let identifiers = getIdentifiers()
        for identifier in identifiers {
            let region = locale.displayName(forKey: NSLocale.Key.identifier, value: identifier)!
            idByRegion[region] = identifier
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
    
    
    //MARK: - Data Transfer
    func sendVoicesToSettingVC() {
        let settingsVC = getSettingsVC()
        settingsVC.idByRegion = self.idByRegion
    }
    
    func sendSpeechToSettingsVC() {
        let settingsVC = getSettingsVC()
        settingsVC.speech = speech
    }
    
    func getSettingsVC() -> SettingsViewController {
        let tabBarControllers = self.tabBarController?.viewControllers
        let settingsViewController = tabBarControllers?[1] as! SettingsViewController
        return settingsViewController
    }
    
    
    //MARK: - Read Text
    
    func tap() {
        button.buttonState = .play
        let text = getText()
        readText(text)
    }
    
    
    func getText() -> String{
        var text = ""
        if TextView.text != "" {
            text = TextView.text!
        }else{
            text = "Sorry, There is no text to read"
        }
        speech?.setSpeechText(text)
        return text
    }
    
    
    func readText(_ text: String){
        speechUtterance = AVSpeechUtterance(string: text)
        
        speechUtterance.rate = speech.rate
        speechUtterance.pitchMultiplier = speech.multiplier
        speechUtterance.volume = speech.volume
        speechUtterance.voice = AVSpeechSynthesisVoice(language: speech.language)
        synthesizer.speak(speechUtterance)

    }
    
}

