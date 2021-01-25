//
//  CubeType+CoreDataProperties.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/19/20.
//
//

import Foundation
import CoreData


extension CubeType: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CubeType> {
        return NSFetchRequest<CubeType>(entityName: "CubeType")
    }

    @NSManaged public var id: UUID?
    
    public func getUUIDString() -> String? {
        if id == nil {
            return "no-id"
        } else {
            return id?.uuidString
        }
    }
    
    public func isCustom() -> Bool {
        if customName != nil {
            if !customName!.isEmpty {
                return true
            }
        }
        return false
    }
    
    
    
    
    public func equals(_ ct: CubeType) -> Bool {
        if self.id == ct.id {
            return true
        }else {
            return false
        }
    }
    
    public func toString() -> String {
        return self.name + ", " + self.descrip
    }
    

}

extension CubeType {
    
    /*
     * the related solves
     
     * lets hope this is the solutions were looking for and we dont have to setup the relationship outself
     */
    @NSManaged public var solves: NSSet
    public var solvesArray: [SolveItem] {
        let set = solves as? Set<SolveItem> ?? []
        return set.sorted {
            $0.timestamp < $1.timestamp
        }
    }
    
    @NSManaged public var customName: String?
    var cstmName: String {
        set {
            customName = newValue
        }
        get {
            return customName ?? "No Name Set"
        }
    }
    
    /*
    @NSManaged public var scrambleRaw: String?
    var scramble: String {
        set {
            scrambleRaw = newValue
            //scrambleRaw = newValue.string
        }get {
            /*
            let stringAsData = scrambleRaw?.data(using: String.Encoding.utf16)
            let array: [String] = try! JSONDecoder().decode([String].self, from: stringAsData!)
            
            return array
            */
            //return Scramble(raw: scrambleRaw)
            return scrambleRaw ?? "No scramble found"
        }
    }
    */
    

    
    @NSManaged public var d1: Int16
    var dim1: Int {
        set {
            d1 = Int16(newValue)
        }
        get {
            return Int(d2)
        }
    }
    
    @NSManaged public var d2: Int16
    var dim2: Int {
        set {
            d2 = Int16(newValue)
        }
        get {
            return Int(d2)
        }
    }
    
    @NSManaged public var d3: Int16
    var dim3: Int {
        set {
            d3 = Int16(newValue)
        }
        get {
            return Int(d3)
        }
    }
    
    var dimensions: [Int] {
        set{
            d1 = Int16(newValue[0])
            d2 = Int16(newValue[1])
            d3 = Int16(newValue[2])
        }
        get {
            return [Int(d1), Int(d2), Int(d3)]
        }
    }
    
    @NSManaged public var rawName: String?
    
    var name: String {
        set {
            rawName = newValue
        }
        get {
            return rawName ?? "No Name"
        }
    }
    
    @NSManaged public var desc: String?
    
    var descrip: String {
        set {
            desc = newValue
        }
        get {
            return desc ?? "No Description"
        }
    }
    
    @NSManaged public var size: Int64
    
    var count: Int {
        set {
            size = Int64(newValue)
        }
        get {
            return Int(size)
        }
    }
    
    @NSManaged public var lastModified: Date?
    
    var lm: Date {
        set {
            lastModified = newValue
        }
        get {
            return lastModified!
        }
    }
    
}
