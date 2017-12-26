//
//  ViewController.swift
//  eTalk
//
//  Created by Miltan on 12/24/17.
//  Copyright © 2017 Milton. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechViewController: UIViewController, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var buttonView: UIView!
    
    var languageByRegion = [String: String]()
    var synthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance!
    var playPauseButton: LSPlayPauseButton!
    
    
    var speech: Speech!
    var speechPaused: Bool!
    
    //MARK: - VIEW ACTIVITY
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
        
        speech = Speech()
        speechPaused = false
        
        createButton()
        getRegions()
        sendVoicesToSettingVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendSpeechToSettingsVC()
    }
    
    
    //MARK: - FETCH DATA AND UPDATE UI
    
    func createButton() {
        playPauseButton = LSPlayPauseButton(frame: CGRect(x: 0, y: 0, width: buttonView.layer.bounds.width, height: buttonView.layer.bounds.height), style: .youku, state: .pause)
        playPauseButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        playPauseButton.buttonState = .pause
        buttonView.addSubview(playPauseButton)
    }
    
    
    func getRegions() {
        let locale = NSLocale(localeIdentifier: "en_US")
        
        let languages = getLanguages()
        for language in languages {
            let region = locale.displayName(forKey: NSLocale.Key.identifier, value: language)!
            languageByRegion[region] = language
        }
    }
    
    func getLanguages() -> [String]{
        var languageList = [String]()
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for voice in voices {
            languageList.append(voice.language)
        }
        return languageList
    }
    
    
    //MARK: - DATA TRANSFER
    func sendVoicesToSettingVC() {
        let settingsVC = getSettingsVC()
        settingsVC.languageByRegion = self.languageByRegion
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
    
    
    //MARK: - READ TEXT
    
    func tap() {
//        button.buttonState = .play
        
        if speechPaused == false{
            synthesizer.continueSpeaking()
            speechPaused = true
        }else{
            speechPaused = false
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
        }
        
        if synthesizer.isSpeaking == false {
            let text = getText()
            readText(text)
        }
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
    
    
    
    //MARK: - AVSpeechSynthesiser Delegate
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let fullTextRange = NSMakeRange(0, characterRange.location)
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName,
                                             value: UIColor(colorLiteralRed: 81/255, green: 121/255, blue: 80/255, alpha: 1.0) ,
                                             range:  fullTextRange)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: characterRange)
        TextView.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        playPauseButton.buttonState = .play
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        playPauseButton.buttonState = .pause
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        playPauseButton.buttonState = .play
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        speechPaused = false
        playPauseButton.buttonState = .pause
    }
    
}

