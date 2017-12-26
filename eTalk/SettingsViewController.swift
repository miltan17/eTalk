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
    
    
    var languageByRegion = [String: String]() // [Region: Language]
    var speech: Speech!
    
    var regions = [String]()
    
    //MARK: - VIEW ACTIVITY
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        utterVoice.dataSource = self
        utterVoice.delegate = self
        
        getVoiceRegion()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateSpeech()
    }

    
    //MARK: - DATA FETCH AND UPDATE UI
    func getVoiceRegion() {
        for ( region , _ ) in languageByRegion {
            regions.append(region)
        }
        regions.sort()

    }
    
    
    func updateUI() {
        UIView.animate(withDuration: 0.5, animations: {
            self.utterRate.setValue(self.speech.rate, animated: true)
            self.utterMultiplier.setValue(self.speech.multiplier, animated: true)
            self.utterVolume.setValue(self.speech.volume, animated: true)
            self.setUtterVoicePicker()
        })
    }
    
    
    func setUtterVoicePicker(){
        let language = speech.language
        
        let region = getRegion(language)
        if region != "" {
            if let index = regions.index(of: region){
                utterVoice.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    
    
    func getRegion(_ language: String) -> String {
        let regions = languageByRegion.keys
        for region in regions {
            if languageByRegion[region]! == language {
                return region
            }
        }
        return ""
    }
    
    
    func updateSpeech(){
        speech.setRate(utterRate.value)
        speech.setVolume(utterVolume.value)
        speech.setMultiplier(utterMultiplier.value)
        let region = regions[utterVoice.selectedRow(inComponent: 0)]
        speech.setLanguage(getLanguage(region))
    }
    
    
    func getLanguage(_ region: String) -> String{
        let language = languageByRegion[region]!
        
        return language
    }
    
    
    //MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regions.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return regions[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let color = UIColor(colorLiteralRed: 92/255, green: 94/255, blue: 102/255, alpha: 1.0)
        let titleData = regions[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 15.0)!,NSForegroundColorAttributeName: color])
        return myTitle
    }
    
    //MARK: - Button Action
    @IBAction func setDefaultValueClicked(_ sender: UIButton) {
        
        speech.setMultiplier(1.0)
        speech.setRate(0.5)
        speech.setVolume(0.3)
        speech.setLanguage("en-US")
        updateUI()
    }

}
