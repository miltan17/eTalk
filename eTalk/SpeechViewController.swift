//
//  ViewController.swift
//  eTalk
//
//  Created by Miltan on 12/24/17.
//  Copyright © 2017 Milton. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechViewController: UIViewController, AVSpeechSynthesizerDelegate, UITextViewDelegate {

    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var buttonView: UIView!
    
    var languageByRegion = [String: String]()
    var synthesizer = AVSpeechSynthesizer()
    var playPauseButton: LSPlayPauseButton!
    
    
    var speech: Speech!
    var speechPaused: Bool!
    let placeholderText = "Write Some Thing to Read..."
    let warningText = "Sorry, There is no text to read"
    
    //MARK: - VIEW ACTIVITY
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
        TextView.delegate = self
        
        TextView.text = placeholderText
        TextView.textColor = UIColor.lightGray
        
        
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
    
    //MARK: - KEYBOARD DISAPPEAR
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //MARK: -  TEXTVIEW DELEGATE METHOD
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
        
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
        if TextView.text == "" || TextView.text == placeholderText {
            text = warningText
        }else{
            text = TextView.text!
        }
        
        
        speech?.setSpeechText(text)
        return text
    }
    
    
    func readText(_ text: String){
        let speechUtterance = AVSpeechUtterance(string: text)
        
        speechUtterance.rate = speech.rate
        speechUtterance.pitchMultiplier = speech.multiplier
        speechUtterance.volume = speech.volume
        speechUtterance.voice = AVSpeechSynthesisVoice(language: speech.language)
        synthesizer.speak(speechUtterance)
        
    }
    
    
    
    //MARK: - AVSpeechSynthesiser Delegate
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        if utterance.speechString != warningText{
        let alreadyReadTextRange = NSMakeRange(0, characterRange.location)
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName,
                                             value: UIColor(colorLiteralRed: 81/255, green: 121/255, blue: 80/255, alpha: 1.0) ,
                                             range:  alreadyReadTextRange)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: characterRange)
        TextView.attributedText = mutableAttributedString
        
        }
//        let nextString = getNextStringToSpeak(utterance.speechString, characterRange.location)
////        print(nextString)
////        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
//        readText(nextString)
        
    }
    /*
    func getNextStringToSpeak(_ text: String, _ offset: Int) -> String {
        
        let start = text.index(text.startIndex, offsetBy: offset)
        let end = text.endIndex //text.index(text.endIndex, offsetBy: -6)
        let range = start..<end
        
        let mySubstring = text[range]
        let str = String(mySubstring)
        return str!
    }
    */
    
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

