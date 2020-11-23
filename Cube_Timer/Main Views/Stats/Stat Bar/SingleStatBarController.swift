//
//  SingleStatBarController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/23/20.
//

import Foundation
import SwiftUI

/*
 *  This class controls a single stat bar used in the standard deviation bar graph
 */
class SingleStatBarController: ObservableObject, Identifiable {
    
    var id: String = UUID().uuidString
    
    @Published var maxHeight: CGFloat = 30 // this sets the height of the standard deviation bar graph
    @Published var percentage: Double = 0
    
    /*
     *  updated the bar on the display
     */
    func set(pct: Double) {
        self.percentage = pct
        //print("set to percentage: ", self.percentage)
    }
    
    
}
