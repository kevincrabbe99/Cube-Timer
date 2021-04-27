//
//  SettingsController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/2/21.
//

import Foundation
import SwiftUI
import Firebase

enum LanguageOption: String {
    case English = "en"
    case Chinese = "zh"
    case Japanese = "ja"
    case Spanish = "es"
    case French = "fr"
    case German = "de"
    case Russian = "ru"
    case Korian = "ko"
    case Hindi = "hi"
}

class SettingsController: ObservableObject {
    
    var alertController: AlertController!
    
    // each individual setting
    @Published var requireDoublePressToStop: Bool = false
    @Published var pauseSavingSolves:  Bool = false
    @Published var oneButtonMode: Bool = true
    @Published var defaultVideoOn: Bool = false
    @Published var recordingBufferTime: Int = 3
    @Published var defaultLanguage: LanguageOption = .English
    
    // about stuff
    @Published var aboutState: Bool = false // changethis
    
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    init() {
        
        let defaults = UserDefaults.standard
        
        // check if the requireDoublePressToStop keys exist in userDefaults
        if let rsptsVal = defaults.object(forKey: "requireDoublePressToStop") as? Bool {
            // set value from userDefaults
            self.requireDoublePressToStop = rsptsVal
        } else {
           print("No value in requireDoublePressToStop, initializing to false")
            defaults.set(false, forKey: "requireDoublePressToStop")
            self.requireDoublePressToStop = false
            Analytics.setUserProperty("false", forName: "DoublePressStop")
        }
        
        // check for pauseSavingSolves key in userDefaults
        if let pssVal = defaults.object(forKey: "pauseSavingSolves") as? Bool {
            self.pauseSavingSolves = pssVal
        } else {
            print("No value in pauseSavingSolves, initializing to false")
            defaults.set(false, forKey: "pauseSavingSolves")
            self.pauseSavingSolves = false
            Analytics.setUserProperty("false", forName: "pause_saving_solves")
        }
        
        // check if the oneButtonMode is in userDefaults
        if let obmVal = defaults.object(forKey: "oneButtonMode") as? Bool {
            // set from user defaults
            self.oneButtonMode = obmVal
        } else {
            print("No value in oneButtonMode, initializing to false")
            defaults.set(false, forKey: "oneButtonMode")
            self.oneButtonMode = false // changethis
            
            // set analytics
            Analytics.setUserProperty("false", forName: "pause_saving_solves")
        }
        
        // check if defaultToVideoOn is in userDefaults
        if let dvoVal = defaults.object(forKey: "default_to_camera_on") as? Bool {
            // set from user defaults
            self.defaultVideoOn = dvoVal
        } else {
            print("No value in defaultToVideoOn, initializing to false")
            defaults.set(false, forKey: "default_to_camera_on")
            self.oneButtonMode = false // changethis
            
            // set analytics
            Analytics.setUserProperty("false", forName: "default_to_camera_on")
        }
        
        // check if defaultToVideoOn is in userDefaults
        if let rbtVal = defaults.object(forKey: "recording_buffer_timer") as? Int {
            // set from user defaults
            self.recordingBufferTime = rbtVal
        } else {
            print("No value in recording_buffer_timer, initializing to 3")
            defaults.set(3, forKey: "recording_buffer_timer")
            self.recordingBufferTime = 3
            
            // set analytics
            Analytics.setUserProperty("3", forName: "recording_buffer_time")
        }
        
        // check for default language
        if let langVal = defaults.object(forKey: "default_language") as? String {
            // set from user defaults
            self.defaultLanguage = getLangOptFromString( langVal )
        } else {
            print("No value in default_language")
            // get users language
            if let langStr = Locale.current.languageCode {
                defaults.set(langStr, forKey: "default_language")
                self.defaultLanguage = getLangOptFromString( langStr )
            } else {
                defaults.set("en", forKey: "default_language")
                self.defaultLanguage = getLangOptFromString( "en" )
            }
            
            
            // set analytics
            Analytics.setUserProperty(defaultLanguage.rawValue, forName: "default_language")
        }
        
    }
    
    /*
     * Returns correct format for current language
     */
    var getDefaultLanguage: String {
        return defaultLanguage.rawValue
    }
    
    private func getLangOptFromString(_ str: String) -> LanguageOption {
        
        switch str {
        case "en":
            return .English
        case "zh":
            return .Chinese
        case "ja":
            return .Japanese
        case "es":
            return .Spanish
        case "fr":
            return .French
        case "de":
            return .German
        case "ru":
            return .Russian
        case "ko":
            return .Korian
        case "hi":
            return .Hindi
        default:
            return .English
        }
        
    }
    
    
    /*
     *  sets the state to the about view
     */
    public func toggleAbout() {
        self.aboutState.toggle()
        
        if aboutState {
            Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                AnalyticsParameterDestination: "aboutView"
            ])
        }
    }
    
    public func toggleOneButtonMode() {
        let defaults = UserDefaults.standard
        lightTap.impactOccurred()
        
        if oneButtonMode == false { // set to true
            self.oneButtonMode = true
            Analytics.setUserProperty("false", forName: "oneButtonMode")
        } else {
            self.oneButtonMode = false // turn off
            Analytics.setUserProperty("false", forName: "oneButtonMode")
        }
        
        defaults.set(oneButtonMode, forKey: "oneButtonMode")
    }
    
    /*
     *  toggles state of requireDoublePressToStop and saves to userDefaults
     */
    public func toggleRequireDoublePressToStop() {
        let defaults = UserDefaults.standard
        lightTap.impactOccurred()
        
        if requireDoublePressToStop == false { // set to true
            self.requireDoublePressToStop = true
            Analytics.setUserProperty("false", forName: "DoublePressStop")
        } else {
            self.requireDoublePressToStop = false // turn off
            Analytics.setUserProperty("false", forName: "DoublePressStop")
        }
        
        defaults.set(requireDoublePressToStop, forKey: "requireDoublePressToStop")
    }
    
    /*
     *  toggles state of pauseSavingSolves and saves to userDefaults
     */
    public func togglePauseSavingSolves() {
        let defaults = UserDefaults.standard
        lightTap.impactOccurred()
        
        if pauseSavingSolves == false { // set to true
            self.pauseSavingSolves = true
            
            // show alert
            alertController.makeAlert(icon: Image(systemName: "pause.rectangle.fill"), title: "Pause Saving Solves", text: "Solves will not be saved until you turn pause saving solves back off")
            
            
            Analytics.setUserProperty("true", forName: "pause_saving_solves")
        } else {
            self.pauseSavingSolves = false // turn off
            
            // show alert
            alertController.makeAlert(icon: Image(systemName: "play.rectangle.fill"), title: "Resumed Saving Solves", text: "Solves will not be recorded and saved")
            
            Analytics.setUserProperty("false", forName: "pause_saving_solves")
        }
        
        defaults.set(pauseSavingSolves, forKey: "pauseSavingSolves")
    }
    
    /*
     *  Toggles whether the video is on by default
     */
    public func toggleDefaultVideoOn() {
        let defaults = UserDefaults.standard
        lightTap.impactOccurred()
        
        if defaultVideoOn == false { // set to true
            self.defaultVideoOn = true
            
            // show alert
            alertController.makeAlert(icon: Image(systemName: "video.fill"), title: "Camera default set to enabled", text: "Camera will initiate upon opening the app.")
            
            
            Analytics.setUserProperty("true", forName: "default_to_camera_on")
        } else {
            self.defaultVideoOn = false // turn off
            
            // show alert
            alertController.makeAlert(icon: Image(systemName: "video.slash.fill"), title: "Camera default set to disabled", text: "Camera will not initiate upon opening the app.")
            
            Analytics.setUserProperty("false", forName: "default_to_camera_on")
        }
        
        defaults.set(defaultVideoOn, forKey: "default_to_camera_on")
    }
    
    /*
     * sets time for stop recording buffer
     */
    public func setRecordingBuffer(to: Int) {
        print("recording buffer: ", to)
        
        let newBufferTime = to
        let defaults = UserDefaults.standard
        lightTap.impactOccurred()
        
        // if statement stops from running upon init
        if newBufferTime != self.recordingBufferTime {
            alertController.makeAlert(icon: Image(systemName: "timer"), title: "Recording buffer updated", text: Text("Video recordings will not stop for \(newBufferTime, specifier: "%lld") seconds after the timer is stopped."))
        }
        
        self.recordingBufferTime = newBufferTime
        defaults.set(newBufferTime, forKey: "recording_buffer_timer")
        
        // set analytics
        Analytics.setUserProperty("\(newBufferTime)", forName: "recording_buffer_time")
        
    }
    
    
    /*
     * sets time for stop recording buffer
     */
    public func setLanguage(to: LanguageOption) {
        print("setting language to ", to)
        
        let newLanguage = to
        let defaults = UserDefaults.standard
        lightTap.impactOccurred()
        
        // if statement stops from running upon init
        if self.defaultLanguage != newLanguage {
            alertController.makeAlert(icon: Image(systemName: "timer"), title: "Changed Default Language", text: Text("Changed language to \(newLanguage.rawValue)"))
        }
        
        self.defaultLanguage = newLanguage
        defaults.set(self.defaultLanguage.rawValue, forKey: "default_language")
        
        // set analytics
        Analytics.setUserProperty("\(defaultLanguage)", forName: "default_language")
        
    }
    
    
}
