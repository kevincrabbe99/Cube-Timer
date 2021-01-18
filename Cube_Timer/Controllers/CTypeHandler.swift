//
//  CTypeController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/19/20.
//

import Foundation
import CoreData
import SwiftUI
import Firebase

class CTypeHandler: ObservableObject {
    
    var contentView: ContentView!
    var solveHandler: SolveHandler!
    var allSolvesController: AllSolvesController!
    
    var cvc: ContentViewController!
    
    @Published var typeControllers: [SingleCubeTypeViewController] // array with all saved cube types as keys and controllers as values
    @Published var size: Int = 0
    @Published var selected: CubeType! // empty placeholder
    @Published var views: [SingleCubeTypeView] = []
    @Published var tabIcon: AnyView = AnyView(CubeIcon(3, 3, 3, width: 15))
    
    init() {
        
        typeControllers = []
        
        let getCTypesRequest = NSFetchRequest<CubeType>(entityName: "CubeType")
        getCTypesRequest.sortDescriptors = [NSSortDescriptor(key: "lastModified", ascending: false)]
        
        do {
            let result = try PersistenceController.shared.container.viewContext.fetch(getCTypesRequest)
            
            // loop through all solves
            for (r) in result {
              //  let nCT = r as CubeType
                print("CT, ", r)
                self.add(r)
            }
            
        } catch {
            print("error gathering Cube Types from CoreData - CTypeController.swift -> init()")
        }
        
        // check if the CoreData model "CubeType" is empty
            // if so then, add a generic 3x3x3 cube
        if isEmpty() {
            // add a 3x3x3 generic cube
            self.add(d1: 3, d2: 3, d3: 3, desc: "Generic Brand")
        }
        
        // set selections
        //newSelection( typeControllers[0] )
        self.setDefaultSelection()
        
    }
    
    public func setDefaultSelection() {
        
        // set selections
        newSelection( typeControllers[0] )
        
    }
    
    public func getIndexFrom(id: UUID) -> Int {
        let ctController = getControllerFrom(id: id)
        if ctController == nil {
            return -1
        }
        
        for (i, t) in typeControllers.enumerated() {
            if t.ct.id == (ctController!.ct.id) {
                return i
            }
        }
        return -1
    }
    
    public func getControllerFrom(id: UUID) -> SingleCubeTypeViewController? {
        for t in typeControllers {
            if t.ct.id == id {
                return t
            }
        }
        return nil
    }
    
    
    /*
     *  this is called by SingleCubeTypeViewController and is used to refresh the view
     */
    public func newSelection(_ ctController: SingleCubeTypeViewController) {
        
        
        // go through and deselect all of them
        for t in typeControllers {
            if t.ct.id != ctController.ct.id { // if it does not match the passed controller then deselect it
                t.unselect() 
            }
        }
        
        // this only does something if the passed ctController isnt selected
        ctController.select()
        
        // update tab icon
        self.selected = ctController.ct
        print("updating tab icon ", selected!.dim1, selected!.dim2, selected!.dim3)
        self.tabIcon = AnyView(CubeIcon(selected!.dim1, selected!.dim2, selected!.dim3, width: 15))
        
        // update the SolveHandler
        if solveHandler != nil {
            solveHandler.updateSolves(to: .All) // update for the solves handler
            allSolvesController.updateSolves() // update for the grid view
            //solveHandler.setTimeFrame(.Today)
        }
        
        
        // google analytics update selected puzzle
        updateGASelectedPuzzle()
        
        
    }
    
    public func showEditPopupFor(id: UUID) {
        print("passed through CTypeHandler")
        cvc.showCTPopupFor(id: id)
    }
    
    public func getDefaultSelection() -> CubeType? {
        if size > 0 {
            return typeControllers[0].ct
        }
        return nil
    }
    
    /*
    public func select(_ ct: CubeType) {
        self.selected = ct
    }
    
    public func isSelected(_ ct: CubeType) -> Bool {
        if selected == nil {
            return false
        }
        
        if selected!.equals(ct) {
            return true
        }
        return false
    }
    */
    
    public func has(_ ct: CubeType) -> Bool {
        for t in typeControllers {
            if t.ct.id == ct.id {
                return true
            }
        }
        return false
    }
    
    public func isEmpty() -> Bool {
        if size <= 0 {
            return true
        }
        return false
    }
    
    
    /*
     *  Called whenever a cube is added by SolvesData.swift
     */
    public func updateModifiedDateForSelected() {
        self.selected.setValue(Date(), forKey: "lastModified")
        
        // reorder the typeControllers
        self.typeControllers = typeControllers.sorted { $0.ct.lastModified! > $1.ct.lastModified! }
    }
    
    /*
     *  This method calls the delte from CoreData method (right below)
     
     NEED TO ADD, check if its selected and select a new one
     */
    public func delete(_ id: UUID) {
        let refToDelete = getControllerFrom(id: id) // create a ref before deleting
        if refToDelete == nil { // escape is the ref is nil
            print("Can't delete that, it doesnt exist")
            return
        }
        
        let i = getIndexFrom(id: id)
        self.typeControllers.remove(at: i)
        self.size  -= 1
        
        CTypeHandler.DeleteCtFromCoreData(ct: refToDelete!.ct) // passes a reference to the static function
    
        /*
         * GOOGLE ANALYTICS STUFF
         
         *  send delete puzzle event
         */
        Analytics.logEvent("deleted_puzzle", parameters: [
            "puzzle_name": refToDelete!.rawName as NSObject,
            "puzzle_description": refToDelete!.ct.description as NSObject
        ])
        
        // update total puzzles for user
        updateGATotalPuzzles()
    }
    
    /*
     * be careful when using this as it only deletes the CoreData reference, NOT the array reference
     */
    private static func DeleteCtFromCoreData(ct: CubeType) {
        
        PersistenceController.shared.container.viewContext.delete(ct)
        
        do {
            try PersistenceController.shared.container.viewContext.save()
            print("Fully deleted the CT")
        } catch {
            print("Cant delete item from CoreData, but it should be deleted from the array")
        }
        
    }
    
    public func getCubeTypes() -> [CubeType] {
        var res: [CubeType] = []
        
        for ctController in typeControllers {
            res.append(ctController.ct)
        }
        
        return res
    }
    
    
    
    /*
     *  Checks if there is a controller present for the given cube type
     */
    public func hasControllerFor(_ ct: CubeType) -> Bool {
        for t in typeControllers {
            if t.ct.equals(ct) {
                return true
            }
        }
        
        return false
    }
    
    public func edit(_ ct: CubeType, d1: Int, d2: Int, d3: Int, desc: String) {
        print("set to: ", d1, d2, d3, desc)
        ct.setValue(d1, forKey: "d1")
        ct.dim1 = d1
        ct.setValue(d2, forKey: "d2")
        ct.dim2 = d2
        ct.setValue(d3, forKey: "d3")
        ct.dim3 = d3
        
        let rawName: String = String(d1)+"x"+String(d2)+"x"+String(d3)
        ct.setValue(rawName, forKey: "rawName")
        ct.rawName = rawName
        
        ct.setValue(desc, forKey: "desc")
        ct.desc = desc
        ct.setValue(Date(), forKey: "lastModified")
        
        do {
            try PersistenceController.shared.container.viewContext.save()
            print("Cube Type Saved!")
        } catch {
            print("SAVE ERROR: saving a new CubeType, CTypeController.swift -> edit")
        }
        
        for tc in typeControllers {
            tc.updateFromCTObj()
        }
        
        /*
         * ANALYTICS, Log Edited Puzzle
         */
        Analytics.logEvent("edited_puzzle", parameters: [
            "puzzle_name": ct.name as! NSObject,
            "puzzle_description": ct.descrip as NSObject
        ])
    }
    
    
    /*
     *  Used to add a CubeType object and the array references ONLY
     *      This is how prestored elements are loaded in
     */
    public func add(_ ct: CubeType) {
        
        // check if a controller already exists
        if hasControllerFor(ct) {
            return
        }
        
        // if not then create the controller
        let newCTController = SingleCubeTypeViewController(ct: ct, ctHandler: self)
        //newCTController.initView()
        
        // add the controller to the array
        self.typeControllers.append(newCTController)
        
        // increase array size reference
        self.size += 1
    }
    
    
    /*
     *  Adds a solve element based on given attributes
            * This is how we add new solves from user input
            * any other implementations should be reconcidered
     */
    public func add(d1: Int, d2: Int, d3: Int, desc: String) {
        // add to core data
        let newCT = CTypeHandler.AddCtToCoreData(d1: d1, d2: d2, d3: d3, desc: desc)
        
        // create controller reference
        let newCTController = SingleCubeTypeViewController(ct: newCT, ctHandler: self)
        //newCTController.initView()
        self.typeControllers.append(newCTController)
        
        self.size += 1
        
        /*
         *  GOOGLE ANALYTICS, log created_puzzle
         */
        Analytics.logEvent("created_puzzle", parameters: [
            "puzzle_name": newCT.name as NSObject,
            "puzzle_description": newCT.descrip as NSObject
        ])
        
        // update the total puzzles for the user
        updateGATotalPuzzles()
    }
    
    public static func AddCtToCoreData(d1: Int, d2: Int, d3: Int, desc: String) -> CubeType {
        
        // create a raw CubeType with no data
        let newCT = CubeType.init(entity: CubeType.entity(), insertInto: PersistenceController.shared.container.viewContext)
        
        // add all the data
        newCT.id = UUID()
        newCT.d1 = Int16(d1)
        newCT.d2 = Int16(d2)
        newCT.d3 = Int16(d3)
        newCT.rawName = String(d1)+"x"+String(d2)+"x"+String(d3)
        newCT.desc = desc
        newCT.lastModified = Date()
        newCT.size = 0
        
        do {
            try PersistenceController.shared.container.viewContext.save()
            print("Cube Type Saved!")
        } catch {
            print("SAVE ERROR: saving a new CubeType, CTypeController.swift -> addCtToCoreData")
        }
        return newCT
        
    }
    
    
    /*
     *  Google Analytics stuff
     */
    private func updateGATotalPuzzles() {
        Analytics.setUserProperty("\(self.typeControllers.count)", forName: "total_puzzles")
    }
    
    private func updateGASelectedPuzzle() {
        Analytics.setUserProperty("\(self.selected.toString())", forName: "last_puzzle_selected")
    }
    
}


