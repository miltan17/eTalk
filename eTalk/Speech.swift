

import Foundation


class Speech {
    private var _speechText: String?
    private var _rate: Float?
    private var _multiplier: Float?
    private var _volume: Float?
    private var _language: String?
    
    var speechText: String {
        return _speechText!
    }
    
    var rate: Float {
        return _rate!
    }
    
    var multiplier: Float {
        return _multiplier!
    }
    
    var volume: Float {
        return _volume!
    }
    
    var language: String {
        return _language!
    }
    
    func setSpeechText(_ text: String){
        _speechText = text
    }
    
    func setRate(_ rate: Float) {
        _rate = rate
    }
    
    func setMultiplier(_ multiplier: Float) {
        _multiplier = multiplier
    }
    
    func setVolume(_ volume: Float) {
        _volume = volume
    }
    
    func setLanguage(_ language: String) {
        _language = language
    }
    
    
    init() {
        self._speechText = ""
        self._multiplier = 1.0
        self._rate = 0.5
        self._volume = 0.1
        self._language = "en_US"
    }

}
