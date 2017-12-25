//
//  SettingsViewController.swift
//  eTalk
//
//  Created by Miltan on 12/25/17.
//  Copyright © 2017 Milton. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    
    @IBOutlet weak var utterRate: UISlider!
    @IBOutlet weak var utterMultiplier: UISlider!
    @IBOutlet weak var utterVolume: UISlider!
    @IBOutlet weak var utterVoice: UIPickerView!
    
    
    var idByRegion = [String: String]()
    var speech: Speech!
    
    var voice = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        utterVoice.dataSource = self
        utterVoice.delegate = self
        
        getVoiceRegion()
    }
    
    func getVoiceRegion() {
        for ( region , _ ) in idByRegion {
            voice.append(region)
        }
        voice.sort()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Speech Found Here")
        updateUI()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Settings Will Disappare")
        updateSpeech()
    }
    
    func updateUI() {
        utterRate.value = speech.rate
        utterMultiplier.value = speech.multiplier
        utterVolume.value = speech.volume
        
        // work with utter voice picker
    }
    
    func updateSpeech(){
        speech.setRate(utterRate.value)
        speech.setVolume(utterVolume.value)
        speech.setMultiplier(utterMultiplier.value)
        speech.setLanguage(getLanguage())
    }
    
    func getLanguage() -> String{
        let region = voice[utterVoice.selectedRow(inComponent: 0)]
        let language = idByRegion[region]!
        
        return language
    }
    
    
    //MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return voice.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return voice[row]
    }
    

}
