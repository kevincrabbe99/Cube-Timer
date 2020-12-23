//
//  SolveItem+CoreDataProperties.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/25/20.
//
//

import Foundation
import CoreData

/*
enum PuzzleType: String {
    case pending = "pending..."
    case a3x3x3 = "3x3x3"
    case a4x4x4 = "4x4x4"
    case a5x5x5 = "5x5x5"
    case a6x6x6 = "6x6x6"
}
 */

/*
enum PuzzleBrand: String {
    case pending = "pending..."
    case rubiks = "Rubiks Brand"
}
 */

extension SolveItem: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SolveItem> {
        return NSFetchRequest<SolveItem>(entityName: "SolveItem")
    }

    @NSManaged public var id: String
    @NSManaged public var timeMS: Double
    @NSManaged public var timestamp: Date
    
    @NSManaged public var cubeType: CubeType
    

    
    func getTimeCapture() -> TimeCapture? {
        return TimeCapture.init(timeMS )
    }
    
    /*
     *  Returns a formatted date
     */
    func getDateString() -> String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return formatter1.string(from: timestamp)
    }
    
    func getApplicableTimeframes() -> [Timeframe] {
        var res: [Timeframe] = []
        let now = Date()
        
        // check for today
        if Calendar.current.isDateInToday(timestamp) {
            res.append(.Today)
        }
        
        // check for this month
        let monthAgo: Date = Calendar.current.date(byAdding: .month, value: -1, to: now)!
        let rangeM = monthAgo...now
        if rangeM.contains(timestamp) {
            res.append(.OneMonth)
        }
        
        // check for last 3 months
        let threeMonthAgo: Date = Calendar.current.date(byAdding: .month, value: -3, to: now)!
        let range3M = threeMonthAgo...now
        if range3M.contains(timestamp) {
            res.append(.ThreeMonths)
        }
        
        // check for one year
        let yearAgo: Date = Calendar.current.date(byAdding: .year, value: -1, to: now)!
        let rangeY = yearAgo...now
        if rangeY.contains(timestamp) {
            res.append(.Year)
        }
        
        return res
    }
    
    public func equals(_ s: SolveItem) -> Bool {
        if self.id == s.id {
            return true
        }else {
            return false
        }
    }
    
}

extension SolveItem {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "timestamp", ascending: true)]
    }
    static var sortedFetchRequest: NSFetchRequest<SolveItem> {
        let request: NSFetchRequest<SolveItem> = SolveItem.fetchRequest()
        request.sortDescriptors = SolveItem.defaultSortDescriptors
        return request
    }
    static var solvesFetchRequest: NSFetchRequest<SolveItem> {
        let request = SolveItem.sortedFetchRequest
        // request.predicate = NSPredicate(format: "visited == true")
        return request
    }
}

extension SolveItem {
    
    /*
    @NSManaged public var type: String
    
    var cubeType: PuzzleType {
        set {
            type = newValue.rawValue
        }
        get {
            PuzzleType(rawValue: type) ?? .pending
        }
    }
    
    @NSManaged public var brand: String
    
    var cubeBrand: PuzzleBrand {
        set {
            brand = newValue.rawValue
        }
        get {
            PuzzleBrand(rawValue: brand) ?? .pending
        }
    }
    */
    
    static func getAllItems() -> NSFetchRequest<SolveItem> {
        let request: NSFetchRequest<SolveItem> = NSFetchRequest<SolveItem>(entityName: "SolveItem")
        
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        return request
    }
    
}

