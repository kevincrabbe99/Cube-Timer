//
//  SettingsController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/2/21.
//

import Foundation
import SwiftUI
import Firebase

class SettingsController: ObservableObject {
    
    var alertController: AlertController!
    
    // each individual setting
    @Published var requireDoublePressToStop: Bool = false
    @Published var pauseSavingSolves:  Bool = false
    
    // about stuff
    @Published var aboutState: Bool = false
    
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
    
    
}
