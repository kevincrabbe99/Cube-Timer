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
    //var solveHandler: SolveHandler!
    
    @Published var solves: [SolveItem] // array which changes to correspond with timeframe
    @Published var size: Int = 0
    
    // STATS to be displayed
    @Published var average: TimeCapture = TimeCapture()
    @Published var best: TimeCapture = TimeCapture()
    @Published var last3: [SolveItem] = []
    
    
    // sets the initial timeframe
    @Published var currentTimeframe: Timeframe = .Today   // sets .Today as initial timeFrame
    
    /* New way below :) */
    // initiates an empty solves by timeframe object
    @ObservedObject var solvesByTimeFrame: SolvesFromTimeframe = SolvesFromTimeframe();
    // self.barGraphController is a instance of a bar graph
    //  this is for the homescreen standard deviation graph preview
    @ObservedObject var barGraphController: BarGraphController = BarGraphController()
    
    
    init() {
        
        // initialize solves to be empty
        solves = []
        
        // initialize self.barGraphController with a new instance of a bar graph (BarGraphController.swift)
        barGraphController = BarGraphController(parent: self)
        
        // setup for CoreData
        let solveRequest = NSFetchRequest<SolveItem>(entityName: "SolveItem")
        solveRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            let results = try PersistenceController.shared.container.viewContext.fetch(solveRequest)
            
            //print("worked fetched: ", results)
            for (index, re) in results.enumerated() {
                //print("Item \(index) = ", re.timeMS);
                print("Solve Item IMPORTED: ", re as SolveItem)
                
                self.add(re as SolveItem)
            }
           
            updateSolves(to: currentTimeframe) // sets timeframe and updates everything
            
        }catch  {
            print("error fetching solves: ")
        }
        
        /*
         for testing add a solve from yesterday
         
        self.addCostumSolve(sec: 33)
        self.addCostumSolve(sec: 34)
        self.addCostumSolve(sec: 35)
        self.addCostumSolve(sec: 36)
//      */
    }
    
    /*
     *  Adds a costum defined solve to the dataset
     *  FOR DEV PURPOSES ONLY
     */
    private func addCostumSolve(sec: Double) {
        let newSolve = SolveItem.init(entity: SolveItem.entity(), insertInto: PersistenceController.shared.container.viewContext)
        newSolve.brand = "Rubiks Brand"
        newSolve.cubeType = .a3x3x3
        newSolve.id = UUID().uuidString
        newSolve.timeMS = sec
        newSolve.timestamp = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        newSolve.type = "3x3x3"
        
        // add the new solve
        self.add(newSolve)
        
        // save the new solve
        do {
            try PersistenceController.shared.container.viewContext.save()
                print("Solve Saved!")
            //presentationMode.wrappedValue.dismiss()  //idk
        } catch {
            print("SAVE ERROR: ", error.localizedDescription)
        }
        
    }
    
    
    /*
     *  Returns an array of the timeframs which are needed for all the solves
     */
    func getApplicableTimeframes() -> [Timeframe] {
        return solvesByTimeFrame.getApplicableTimeframes()
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
    
    /*
     *  Updated every solvesByTimeFrame by replacing contents with self.getSolvesFrom(timeframe: .TimeFrame)
     *  Called when a solve is added or deleted via self.delete() & self.updateDisplay()
     
     *  NEEDS TO BE REPLACED, change it so that it updates the SolveFromTimeframe().solves
     #1 DELETED: idk why this is needed
     
    func updateTimeframes() {
        
        // this is assuming that the solves in solvesByTimeFrame were already updated
        self.solves = self.solvesByTimeFrame.getSolvesFrom(timeframe: currentTimeframe)
        
    }
     */
    
    /*
     *  Deleted a solveItem, returns false if was not able to
     */
    func delete(_ s: SolveItem) -> Bool{
        
        let deleteIndex = getIndexOf(s)
        if deleteIndex != -1 {
            
            print("Deleting from CoreData")
            
            // this deletes
            PersistenceController.shared.container.viewContext.delete(s)
            
            do { // saving it 
                try PersistenceController.shared.container.viewContext.save()
                self.solvesByTimeFrame.delete(s) // delete SolvesFromTimeframe() reference
                //updateEverything() // updates EVERYTHING
            } catch {
                print("error deleting solve")
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
    func add(_ s: SolveItem) {
        
        print("adding new solve: ", s.timeMS)
        
        /*
        size += 1
        solves.append(s)
        */
        // (new way) adds to SolveFromTimeframe().solves
        self.solvesByTimeFrame.add(s)
        
        
        updateSolves()
    }
    
    func getSolvesOrderedByTime() -> [SolveItem] {
        return solves.sorted(by:{ $0.timestamp < $1.timestamp })
    }
    
    func getSolvesNewestFirst() -> [SolveItem] {
        return solves.sorted(by:{ $0.timestamp > $1.timestamp })
    }
    
/*
 *  THIS IS ALL UPDATING DISPLAY METHODS
*/
    
    /*
     *  Updates the solves and the display
     *  CALLED BY: self.add() & self.delete()
     *  CALLS: self.updateSolves(), then self.updateDisplay()
    func updateEverything() {
        self.updateSolves()
        //self.updateDisplayStats()
    }
    /*              OVERLOAD METHOD FOR ^
     *  Sets the currentTimeframe, then Updates the solves and the display stats
     *  CALLED BY:
     *  CALLS: self.updateSolves(), then self.updateDisplay()
     */
    func updateEverything(to: Timeframe) {
        self.updateSolves(to: currentTimeframe)
        //self.updateDisplayStats()
    }
     */
    
    /*
     *  Sets the solves array based on the PROVIDED TIMEFRAME
     *  CALLED BY: self.updateEverything(to: Timeframe)
     *  CALLS: NOTHING
     */
    func updateSolves(to: Timeframe) {
        print("Updating solves (& tf) from ", self.size, "elements")
                
        self.currentTimeframe = to
        self.solves = self.solvesByTimeFrame.getSolvesFrom(timeframe: to) // sets the self.solves to solves iterated by SolvesFromTimeFrame.swift
        self.size = solves.count // update count
        
        print("Updating (& tf) solves to ", self.size, "elements")
        
        self.updateDisplayStats()
    }
    /*          OVERLOAD METHOD FOR ^
     *  Sets the solves array BASED ON self.currentTimeframe
     *  CALLED BY: updateEverything()
     *  CALLS: NOTHING
     */
    func updateSolves() {
        print("Updating just solves from ", self.size, "elements")
        
        self.solves = self.solvesByTimeFrame.getSolvesFrom(timeframe: currentTimeframe) // sets the self.solves to solves iterated by SolvesFromTimeFrame.swift
        self.size = solves.count
        
        print("Updating just solves to ", self.size, "elements")
        
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
        
        // animate the bars
        if self.currentTimeframe == .LastThree { // hide the bars if it is last3
            barGraphController.animateOut()
        }else {
            barGraphController.updateBars()        // updates self.bars to be the correct height
        }

        updateBest()        // updates self.best
        updateLast3()       // updates self.last3
        updateAverage()     // updates self.average
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
    
    func getLastSolve() -> SolveItem {
        let orderedSolves = self.getSolvesNewestFirst()
        return orderedSolves[0]
    }
    
    
}

