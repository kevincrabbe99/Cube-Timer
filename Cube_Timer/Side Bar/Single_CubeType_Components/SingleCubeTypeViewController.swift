//
//  SingleCubeTypeViewController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/21/20.
//

import Foundation
import SwiftUI

class SingleCubeTypeViewController: ObservableObject, Identifiable {
    
    var id: UUID
    var ct: CubeType
    var ctHandler: CTypeHandler
    
    // the whole view
    var view: SingleCubeTypeView?
    
    // the attributes which the view pulls from
    @Published var d1: Int = 1
    @Published var d2: Int = 1
    @Published var d3: Int = 1
    @Published var rawName: String = "something went wrong :( 189jf"
    @Published var desc: String = "something went wrong :( d12j"
    @Published var selected: Bool = false
   // @Published var editMode: Bool = false
    
    
    init(ct: CubeType, ctHandler: CTypeHandler) {
        self.id = ct.id!
        self.ct = ct
        self.ctHandler = ctHandler
        
        self.updateFromCTObj()
        // generate the view
            // wait we fucking cant
    }
    
   
    
 
    /*
     *  grabs the values from ctHandler and updates local attributes
     */
    public func updateFromCTObj() {
        self.d1 = ct.dim1
        self.d2 = ct.dim2
        self.d3 = ct.dim3
        self.rawName = ct.name
        self.desc = ct.descrip
        // the reason its not showing the updated names is because im never updating these values, theyre not mapped to anything
        // they will be updated whenever there is a change to the CTypeHandler or honestly even from initview
    }
    
    
    
    
 
    
    /*
     *  this is called by SingleCubeTypeView when it is tapped
        * this method updated this class
        * then updated CTypeHandler -> newSelection(ct: CubeType)
     */
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    public func select() {
        if self.selected {
            return
        } else {
            lightTap.impactOccurred()
            self.selected = true
            ctHandler.newSelection(self)
        }
    }
    
    public func unselect() {
        self.selected = false
    }
    
    
    private func hasView() -> Bool {
        if self.view == nil {
            return false
        }
        return true
    }
    
}
