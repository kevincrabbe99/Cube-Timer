//
//  SolveItem+CoreDataProperties.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/25/20.
//
//

import Foundation
import CoreData
import Photos
import SwiftUI

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
    
    /*
     @NSManaged public var d1: Int16
     var dim1: Int {
         set {
             d1 = Int16(newValue)
         }
         get {
             return Int(d2)
         }
     }
     */
    @NSManaged public var videoName: String?
    public var hasVideo: Bool {
        if videoName != nil {
            return true
        }
        return false
    }
    
    
    @NSManaged public var favorite: NSNumber?
    var isFavorite: Bool {
        get {
            if favorite == nil {
                return false
            }
            
            return Bool(favorite!)
        }
        set {
            favorite = NSNumber(value: newValue)
        }
    }
    
    public func toggleFavorite() -> Bool {
        if isFavorite {
            isFavorite = false
        } else {
            isFavorite = true
        }
        
        do {
            try PersistenceController.shared.container.viewContext.save()
            print("Set isFavorite = ", isFavorite)
        } catch {
            print("SAVE ERROR: updating isFavorite to ", isFavorite)
        }
        
        return isFavorite
    }
    
    
    public func saveVideoToPhotos() {
        
        
        if !hasVideo { return }
        
        let videoPathURL = DocumentDirectory.getVideosDirectory().appendingPathComponent(videoName!)
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoPathURL )
        }) { saved, error in
            if saved {
                print("SAVED VIDEO TO CAMERA ROLL")
            }else {
                print("VideoPlayerController.saveVideoToPhotos() | ERROR SAVING VIDEO TO CAMERA ROLL: ", error)
                
            }
        }
        
    }
    
    
    
    func setCubeType(_ ct: CubeType) {
        self.cubeType = ct
    }
 

    
    func getTimeCapture() -> TimeCapture? {
        return TimeCapture.init(timeMS )
    }
    
    func getTimeGroup() -> TimeGroup {
        
        let now = Date()
        let cal = Calendar.current
        
        // check today
        if cal.isDateInToday(timestamp) {
            return .today
        }
        
        // check yesterday
        if cal.isDateInYesterday(timestamp) {
            return .yesterday
        }
        
        // check yesterday - lastweek
        let weekAgo: Date = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let dayAgo: Date = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let rangeW = weekAgo...dayAgo
        if rangeW.contains(timestamp) {
            return .thisWeek
        }
        
        // check last week - this month
        let monthAgo: Date = Calendar.current.date(byAdding: .month, value: -1, to: now)!
        let rangeM = monthAgo...weekAgo
        if rangeM.contains(timestamp) {
            return .thisMonth
        }
        
        // check this month - last month
        let monthAgo2: Date = Calendar.current.date(byAdding: .month, value: -2, to: now)!
        let range2M = monthAgo2...monthAgo
        if range2M.contains(timestamp) {
            return .lastMonth
        }
        
        // check the rest of the monts
        let monthEnum = TimeGroup(rawValue: timestamp.month) ?? .Unknown
        return monthEnum
        
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
    
    
    static func getAllItems() -> NSFetchRequest<SolveItem> {
        let request: NSFetchRequest<SolveItem> = NSFetchRequest<SolveItem>(entityName: "SolveItem")
        
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        return request
    }
    
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

    
    

