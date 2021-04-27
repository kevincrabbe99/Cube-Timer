//
//  AlertController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/2/21.
//

import Foundation
import SwiftUI

class AlertController: ObservableObject {
    
    @Published var showing: Bool = false
    
    @Published var icon: Image?
    @Published var title: String?
    @Published var text: String = ""
    @Published var textAsLabel: Text? = nil
    @Published var iconColor: Color = Color.black
    
    public func makeAlert(
        icon: Image?,
        title: String?,
        text: String,
        duration: Double = 5,
        iconColor: Color = Color.black
    ) {
        self.icon = icon
        self.title = title
        self.text =  text
        self.iconColor = iconColor
        
        // reset label (localization purposes)
        self.textAsLabel = nil
        
        if self.showing  {
            self.showing = false
        }
        // set to showing
        self.showing = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.showing = false
        }
    }
    
    
    /*
     * Initializer that accepts Text TYPE for self.text
     *  Made for localization purposes
     */
    public func makeAlert(
        icon: Image?,
        title: String?,
        text: Text,
        duration: Double = 5,
        iconColor: Color = Color.black
    ) {
        self.icon = icon
        self.title = title
        self.textAsLabel =  text
        self.iconColor = iconColor
        
        if self.showing  {
            self.showing = false
        }
        // set to showing
        self.showing = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.showing = false
        }
    }
    
    /*
     *  returns the correct description label to the view
     *  made for localization purposes
     */
    var descLabel: Text {
        if self.textAsLabel == nil {
            return Text(LocalizedStringKey(self.text))
        } else {
            return self.textAsLabel!
        }
    }
    
    
    public func hideAlert() {
        self.showing = false
    }
    
    
}
