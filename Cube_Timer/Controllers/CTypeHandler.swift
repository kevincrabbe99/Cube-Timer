//
//  CTypeController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/19/20.
//

import Foundation
import CoreData
import SwiftUI


class CTypeHandler: ObservableObject {
    
    @Published var types: [CubeType] // array with all saved cube types
    @Published var size: Int = 0
    @Published var selected: CubeType? // empty placeholder
    @Published var views: [SingleCubeTypeView] = []
    
    init() {
        
        types = []
        
        let getCTypesRequest = NSFetchRequest<CubeType>(entityName: "CubeType")
        getCTypesRequest.sortDescriptors = [NSSortDescriptor(key: "lastModified", ascending: false)]
        
        do {
            let result = try PersistenceController.shared.container.viewContext.fetch(getCTypesRequest)
            
            // loop through all solves
            for (r) in result {
                let nCT = r as CubeType
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
            CTypeHandler.AddCtToCoreData(d1: 3, d2: 3, d3: 3, desc: "Generic Brand")
        }else {
            self.selected = types[0]
        }
        
    }
    
    public func update() {
     // leaving for the night
        
        /*
            this method will be called whenever something happens so that I can update the views so that SidebarView forEach gets updated
            I need to remove the parent and maybe even contentView from SidebarView and manage their functionality via CTypeHandler.views
         */
    }
    
    public func updateAllViews(parentToPass: SidebarView) {
        for t in types {
            // create new view
            var nSCTV: SingleCubeTypeView = SingleCubeTypeView(id: t.id!, parent: parentToPass, contentView: parentToPass.contentView, d1: Int(t.d1), d2: Int(t.d2), d3: Int(t.d3), rawName: t.rawName ?? "er0134", desc: t.desc ?? "er0134")
            
            // check if t is currently selected
            if isSelected(t) {
                nSCTV.select() // if it is then mark it selected
            }
            self.views.append(nSCTV)
        }
    }
    
    public func getAllAsViews(parentToPass: SidebarView) -> [SingleCubeTypeView] {
        // return self.views
        
        var r: [SingleCubeTypeView] = []
        for t in types {
            // create new view
            var nSCTV: SingleCubeTypeView = SingleCubeTypeView(id: t.id!, parent: parentToPass, contentView: parentToPass.contentView, d1: Int(t.d1), d2: Int(t.d2), d3: Int(t.d3), rawName: t.rawName ?? "er0134", desc: t.desc ?? "er0134")
            
            // check if t is currently selected
            if isSelected(t) {
                nSCTV.select() // if it is then mark it selected
            }
            r.append(nSCTV)
        }
        return r
        
    }
    
    public func getFrom(id: UUID) -> CubeType? {
        for t in types {
            if t.id == id {
                return t
            }
        }
        return nil
    }
    
    public func getIndexFrom(id: UUID) -> Int {
        let ct = getFrom(id: id)
        if ct == nil {
            return -1
        }
        
        for (i, t) in types.enumerated() {
            if t.equals(ct!) {
                return i
            }
        }
        return -1
    }
    
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
    
    
    public func has(_ ct: CubeType) -> Bool {
        return types.contains(ct)
    }
    
    public func isEmpty() -> Bool {
        if size <= 0 {
            return true
        }
        return false
    }
    
    /*
     *  This method calls the delte from CoreData method (right below)
     */
    public func delete(_ id: UUID) {
        let refToDelete = getFrom(id: id) // create a ref before deleting
        if refToDelete == nil { // escape is the ref is nil
            print("Can't delete that, it doesnt exist")
            return
        }
        
        let i = getIndexFrom(id: id)
        self.types.remove(at: i)
        self.size  -= 1
        
        CTypeHandler.DeleteCtFromCoreData(ct: refToDelete!) // passes a reference to the static function
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
    
    
    //public func add(
    public func add(d1: Int, d2: Int, d3: Int, desc: String) {
        let newCT = CTypeHandler.AddCtToCoreData(d1: d1, d2: d2, d3: d3, desc: desc)
        self.types.append(newCT)
        self.size += 1
    }
    
    /*
     *  Used to add a CubeType object and the array references ONLY
     */
    public func add(_ ct: CubeType) {
        self.types.append(ct)
        self.size += 1
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
    
}
