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
    @Published var text: String = "something went wrong !id3#)"
    
    public func makeAlert(
        icon: Image?,
        title: String?,
        text: String,
        duration: Double = 5
    ) {
        self.icon = icon
        self.title = title
        self.text = text
        
        if self.showing  {
            self.showing = false
        }
        // set to showing
        self.showing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.showing = false
        }
    }
    
    
    
}
