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
    
    var voices = [String: String]()
    var voice = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        utterVoice.dataSource = self
        utterVoice.delegate = self
        
        setupPrimaryUI()
    }
    
    func setupPrimaryUI() {
        utterRate.value = 0.5
        utterMultiplier.value = 1.0
        utterVolume.value = 0.5
        for ( _ , name ) in voices {
            voice.append(name)
        }
        voice.sort()
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
