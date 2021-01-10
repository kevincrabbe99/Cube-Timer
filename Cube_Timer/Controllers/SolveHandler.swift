//
//  SolveHandler.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import Foundation
import CoreData
import SwiftUI

enum Timeframe: String {
    case Unknown = "unknown"
    case LastThree = "3X"
    case Today = "1D"
    case Week = "1W"
    case OneMonth = "1M"
    case ThreeMonths = "3M"
    case Year = "1Y"
    case All = "ALL"
}


/*
 *  Class which holds the solves array which represents the solves which can be found within the current timeframe
 *  MAIN PURPOSE: Facilitate self.solves
 */
class SolveHandler: ObservableObject {
    
    var timer: TimerController!
    var bo3Controller: BO3Controller!
    /*  controller for the sidebar,
        handles the cube types */
    var sbController: SidebarController!
    var cTypeHandler: CTypeHandler!
    var allSolvesController: AllSolvesController!

    
    @Published var solves: [SolveItem] // array which changes to correspond with timeframe
    @Published var size: Int = 0
    
    // STATS to be displayed
    @Published var average: TimeCapture = TimeCapture()
    @Published var best: TimeCapture = TimeCapture()
    @Published var last3: [SolveItem] = []
    
    
    // sets the initial timeframe
    @Published var currentTimeframe: Timeframe = .Today   // sets .Today as initial timeFrame
    @Published var currentTimeframeButtonPos: Int = 1
    
    /* New way below :) */
    // initiates an empty solves by timeframe object
    @ObservedObject var solvesByTimeFrame: SolvesFromTimeframe = SolvesFromTimeframe();
    // self.barGraphController is a instance of a bar graph
    //  this is for the homescreen standard deviation graph preview
    
   /* @ObservedObject */ var barGraphController: BarGraphController = BarGraphController()
    
    //@EnvironmentObject var barGraphController: BarGraphController
    init() {
        
        // initialize solves to be empty
        solves = []
        
        
        // setup for CoreData
        let solveRequest = NSFetchRequest<SolveItem>(entityName: "SolveItem")
        solveRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            let results = try PersistenceController.shared.container.viewContext.fetch(solveRequest)
            
            //print("worked fetched: ", results)
            for (re) in results {
                //print("Item \(index) = ", re.timeMS);
                print("Solve Item IMPORTED: ", re as SolveItem)
                
                self.add(re as SolveItem)
            }
           
            
        }catch  {
            print("error fetching solves: ")
        }
        
    }
    
    
    /*
     *  Adds a costum defined solve to the dataset
     *  FOR DEV PURPOSES ONLY
     */
    public func addGenericSampleSolves(count: Int = 10) {
        
        for _ in 0..<count {
            self.addCostumSolve(sec: Double.random(in: 31.23..<68.3), daysAgo: Int.random(in: 0..<90))
        }

    }
    
    
    
    /*
     *  Adds a costum defined solve to the dataset
     *  FOR DEV PURPOSES ONLY
     */
    private func addCostumSolve(sec: Double, daysAgo: Int) {
        let newSolve = SolveItem.init(entity: SolveItem.entity(), insertInto: PersistenceController.shared.container.viewContext)
        //newSolve.brand = cTypeHandler.ct.rawName /*"Rubiks Brand"*/
        //newSolve.cubeType = .a3x3x3
        newSolve.id = UUID().uuidString
        newSolve.timeMS = sec
        newSolve.timestamp = Calendar.current.date(byAdding: .day, value: (daysAgo * -1), to: Date())!
        newSolve.cubeType = cTypeHandler.selected
       // newSolve.type = "3x3x3"
        
        // add the new solve
        self.add(newSolve)
        
        // save the new solve
        do {
            try PersistenceController.shared.container.viewContext.save()
                print("[SolveHandler] Solve Saved!")
            //presentationMode.wrappedValue.dismiss()  //idk
        } catch {
            print("[SolveHandler] SAVE ERROR: ", error.localizedDescription)
        }
        
    }
    
    
   
    
    
    
    
    
    
    /*
     *  returns whether the provided .TimeFrame has any values in it
     *  Determins whether the Standard Deviation is shown
     *  Called by StatsBarView.visibility
     
     *  THIS WILL NEED TO BE UPDATED
     #1 simple check if size > 0 implementation
     */
    func isTimeframeNil(_ tf: Timeframe) -> Bool {
        
        // the new way of doing things
        if self.size < 1 {
            return true
        }
        return false;
        
    }
 
    public func deleteLast() {
        self.delete(getLastSolve()!)
    }
    
    /*
     * deletes any solve thats stored in the AllSolvesView.selected array
     * called by DeleteSolvesView popup,
     */
    public func deleteSelectedSolves() {
        for sElController in allSolvesController.selected {
            self.delete(sElController.si)
        }
        allSolvesController.clearSelected()
    }
    
    /*
     *  Deleted a solveItem, returns false if was not able to
     */
    func delete(_ s: SolveItem) -> Bool{
        
        //let deleteIndex = getIndexOf(s)
        if solvesByTimeFrame.exists(solveItem: s) {
            
            print("[SolveHandler] Deleting from CoreData")
            
            // this deletes
            PersistenceController.shared.container.viewContext.delete(s)
            
            do { // saving it 
                try PersistenceController.shared.container.viewContext.save()
                self.solvesByTimeFrame.delete(s) // delete SolvesFromTimeframe() reference
                //updateEverything() // updates EVERYTHING
            } catch {
                print("[SolveHandler.delete(_ s:SolveItem)] error deleting solve")
            }
            
            // update solves gets called upon success ^
            self.updateSolves()
            timer.setDisplayToLastSolve()
            
            return true
        }
        return false
    }
    
    
    /*
     *  Returns the index of a SolveItem from with self.solves
     */
    func getIndexOf(_ match: SolveItem) -> Int {
        var i: Int = -1
        for (index, s) in solves.enumerated() {
            if s.equals(match) {
                i = index
            }
        }
        return i
    }
    
    
    /*
     *  Adds a solve to the solve array (in SolvesFromTimeframe()) then calls self.updateDisplay()
     *  Called by TimerController().stopTimer()
     *          & self.init() when loading in solves from CoreData
     */
    func add(_ s: SolveItem, newEntry: Bool = false) {
        
        print("[SolveHandler] adding new solve: ", s.timeMS)
        
        /*
        size += 1
        solves.append(s)
        */
        // (new way) adds to SolveFromTimeframe().solves
        self.solvesByTimeFrame.add(s, newEntry: newEntry)
        
     
            updateSolves()
        
    }
    
    func getSolvesOrderedByTime() -> [SolveItem] {
        return solves.sorted(by:{ $0.timestamp < $1.timestamp })
    }
    
    func getSolvesNewestFirst() -> [SolveItem] {
        return solves.sorted(by:{ $0.timestamp > $1.timestamp })
    }
    

    
    /*
     *  Sets the solves array based on the PROVIDED TIMEFRAME
     *  CALLED BY: self.updateEverything(to: Timeframe)
     *  CALLS: updateDisplayStats()
     */
    func updateSolves(to: Timeframe) {
        print("[SolveHandler] Updating solves (& tf) from ", self.size, "elements")
                
        setTimeFrame(to)
        
        //self.solves = solves.filter { $0.cubeType == cTypeHandler.selected }
        
        self.size = solves.count // update count
        
        print("[SolveHandler] Updating (& tf) solves to ", self.size, "elements")
        
        self.updateDisplayStats()
    }
    
    public func setTimeFrame(_ tf: Timeframe) {
        self.currentTimeframe = tf
        self.solves = self.solvesByTimeFrame.getSolvesFrom(timeframe: tf) // sets the self.solves to solves iterated by SolvesFromTimeFrame.swift
        self.currentTimeframeButtonPos = getIndexOfTfButton(tf)
    }
    
    
    
    /*
     *  Returns an INT representing the position of that timeframe button within the bottom bar
        CALLED BY: TimeframeBar 
     
     *  NEEDS UPDATING: wtf is going on here
     */
    public func getIndexOfTfButton(_ tf: Timeframe) -> Int {
        
        let applicableTimeframes = solvesByTimeFrame.getApplicableTimeframes()
        
        if !applicableTimeframes.contains(tf) { // return 0 if the tf DNE
            return 0
        }
        
        /*
         *  All variables used to calculate position
         */
        let hasL3: Bool = applicableTimeframes.contains(.LastThree)
        let hasDay: Bool = applicableTimeframes.contains(.Today)
        let hasWeek: Bool = applicableTimeframes.contains(.Week)
        let hasMonth: Bool = applicableTimeframes.contains(.OneMonth)
        let has3Month: Bool = applicableTimeframes.contains(.ThreeMonths)
        let hasYear: Bool = applicableTimeframes.contains(.Year)
        //let hasAll: Bool = applicableTimeframes.contains(.All)
        
        // -1 means DNE
        var L3Pos: Int = 0
        var oneDayPos: Int = 0
        var weekPos: Int = 0
        var monthPos: Int = 0
        var threeMonthsPos: Int = 0
        var yearPos: Int = 0
        var allPos: Int = 0
        /*
         *  Calculates the position of each button depending on the buttons before it
         */
    // L3
        if hasL3 {
            //L3Pos = 0 // set
            oneDayPos += 1
            weekPos += 1
            monthPos += 1
            threeMonthsPos += 1
            yearPos += 1
            allPos += 1
        }
    // 1D
        if hasDay {
            //oneDayPos += 1
            weekPos += 1
            monthPos += 1
            threeMonthsPos += 1
            yearPos += 1
            allPos += 1
        }
    // W
        if hasWeek {
            //oneDayPos += 1
            //weekPos += 1
            monthPos += 1
            threeMonthsPos += 1
            yearPos += 1
            allPos += 1
        }
    // 1M
        if hasMonth {
            //oneDayPos += 1
            //weekPos += 1
            //monthPos += 1
            threeMonthsPos += 1
            yearPos += 1
            allPos += 1
        }
    // 3M
        if has3Month {
            //oneDayPos += 1
            //weekPos += 1
            //monthPos += 1
            //threeMonthsPos += 1
            yearPos += 1
            allPos += 1
        }
    // T
        if hasYear {
            //oneDayPos += 1
            //weekPos += 1
            //monthPos += 1
            //threeMonthsPos += 1
            //yearPos += 1
            allPos += 1
        }
        
    // do not need to implement for ALL
        
        /*
         *  Return calculated position
         */
        switch tf {
            case .LastThree:
                return L3Pos
            case .Today:
                return oneDayPos
            case .Week:
                return weekPos
            case .OneMonth:
                return monthPos
            case .ThreeMonths:
                return threeMonthsPos
            case .Year:
                return yearPos
            case .All:
                return allPos
            default:
                return 1
        }
       
    }
    
    
    
    
    
    
    
    
    /*          OVERLOAD METHOD FOR ^
     *  Sets the solves array BASED ON self.currentTimeframe
     *  CALLED BY: updateEverything()
     *  CALLS: NOTHING
     */
    func updateSolves() {
        print("[SolveHandler] Updating just solves from ", self.size, "elements")
        
        self.solves = self.solvesByTimeFrame.getSolvesFrom(timeframe: currentTimeframe) // sets the self.solves to solves iterated by SolvesFromTimeFrame.swift
        
        /*
        if cTypeHandler != nil { // will stop this from running on startup before cTypeHandler has been assigned
            self.solves = solves.filter { $0.cubeType == cTypeHandler.selected }
        }
         */
            
        self.size = solves.count
        
        print("[SolveHandler] Updating just solves to ", self.size, "elements")
        
        self.updateDisplayStats()
    }
    
    
    
    /*
     *  Calls all the methods to update the dispaly.
     *  CALLERS: self.init(), self.add(), self.delete()
     *  NOTE: Must be called after self.solves is updated
     */
    public func updateDisplayStats(){
        //print("updating display, size = ", size)
        //print("updating display, solve count = ", solves.count)
        
        //updateTimeframes()  // updates self.solves to solves based on current timeframe
        /*updateSolves(from: currentTimeframe) // updates SolveFromTimeFrame().solves array based on current timeframe
         *  Deleted because updateTimeFrames() called (this method) updateDisplay() */
        
        // update the cubeType incase this was called via cTypeHandler
        
        
        // animate the bars
        if self.currentTimeframe == .LastThree { // hide the bars if it is last3
            barGraphController.animateOut()
        }else {
            barGraphController.updateBars()        // updates self.bars to be the correct height
        }
        updateBest()        // updates self.best
        updateLast3()       // updates self.last3
        updateAverage()     // updates self.average
        // must be called after updating average
        if (timer != nil) {
            //timer.updateOverUnderDisplay() // update the timer over/under display
            timer.setDisplayToLastSolve()
        }
        // update BO3 view
        if self.bo3Controller != nil {
            print("[SolveHandler] updating bo4Controller")
            self.bo3Controller.update()
        }
    }
    
    /*
     *  Updates the last 3 display preview via self.last3
     *  Called by self.updateDisplay & self.updateTimeFrames()
     
     *  Needs to be updated to update the SolveFromTimeframe.swift instead of this.solves
     */
    func updateLast3() {
        self.last3 = [] // clear the last3 display
        let orderedSolves = getSolvesOrderedByTime() // get the solves ordered
        if timer != nil { // housekeeping
            self.timer.objectWillChange.send()
        }
        if self.size > 2 { // if more than 2 solves
            self.last3 = [orderedSolves[size - 1],
                          orderedSolves[size - 2],
                          orderedSolves[size - 3]] // set all 3 values
        }else if size <= 2 { // set less than 3 values
            self.last3 = []
            for s in orderedSolves {
                self.last3.append(s)
            }
        }
    }
    
    /*
     *  Finds the best solve and sets it as best time
     *  Called by self.updateDisplay()
     */
    func updateBest() {
        
        if size == 0 {
            best = TimeCapture()
            return
        }
        
        var b: Double = 1000000000000000
        for s in solves {
            if s.timeMS < b {
                b = s.timeMS
            }
        }
        //self.best = convertTime(ms: b)
        self.best = TimeCapture.init(b)
    }
    
    /*
     *  Calculates the average and sets it
     *  Called by self.updateDisplay()
     */
    func updateAverage()  {
        
        if size == 0 {
            average = TimeCapture()
            return
        }
        
        var total:Double = 0
        for s in solves {
            total += s.timeMS
        }
        //average =  convertTime(ms: (total / Double(solves.count)))
        average = TimeCapture.init(total / Double(size))
    }

    
    /*
     *  Returns the SolveItem with the max solve time
     *  Called by self.getRange() and 1 thigs in StatsBarView.swift->body & 2 things in BestOfThreeView.swift->body
     
     *  SHOULD BE MOVED TO SolveHandler.swift
     */
    func getMax() -> SolveItem {
        var max: Double = -1
        var si: SolveItem = SolveItem()
        for s in solves {
            let solve = s as SolveItem
            if max < solve.timeMS {
                max = solve.timeMS
                si = solve
            }
        }
        
        return si
    }
    
    /*
     *  Returns the SolveItem with the min solve time
     *  Called by self.getBars() & self.getRange() and 1 thigs in StatsBarView.swift->body & 2 things in BestOfThreeView.swift->body
     
     *  SHOULD BE MOVED TO SolveHandler.swift
     */
    func getMin() -> SolveItem {
        var min: Double = 99999999999
        var si: SolveItem = SolveItem()
      
        
        for s in solves {
            let solve = s as SolveItem
            if min > solve.timeMS {
                min = solve.timeMS
                si = solve
            }
        }
        
        return si
    }
    
    /*
     *  Returns a TimeCapture of the average solve time
     *  Called 1 thing in StatsBarView.swift->body & 2 things in BestOfThreeView.swift->body
     
     *  SHOULD BE MOVED TO SolveHandler.swift
     */
    func getAverage() -> TimeCapture  {
        var max: Double = 0
        for s in solves {
            let solve = s as SolveItem
            max += solve.timeMS
        }
        
        return TimeCapture(max / Double(size))
    }
    
    /*
     *  Returns the range of solve times as a Double
     *  Called by self.getBars()
     
     *  SHOULD BE MOVED TO SolveHandler.swift
     */
    func getRange() -> Double {
        return getMax().timeMS - getMin().timeMS
    }
    
    func getLastSolve() -> SolveItem? {
        let orderedSolves = self.getSolvesNewestFirst()
        if solves.count > 0 {
            return orderedSolves[0]
        }
        return nil
    }
    
    
}

