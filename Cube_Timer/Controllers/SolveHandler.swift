//
//  SolveHandler.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import Foundation
import CoreData


class SolveHandler: ObservableObject {
    
    var timer: TimerController!
    var solveHandler: SolveHandler!
    
    @Published var solves: [SolveItem]
    var size: Int = 0
    
    @Published var average: TimeCapture = TimeCapture()
    @Published var best: TimeCapture = TimeCapture()

    @Published var last3: [SolveItem] = []
    
   //  The old way of doing things
    @Published var solvesByTimeframe: [SolvesFromTimeframe] = [
        SolvesFromTimeframe(.LastThree),
        SolvesFromTimeframe(.Today),
        SolvesFromTimeframe(.OneMonth),
        SolvesFromTimeframe(.ThreeMonths),
        SolvesFromTimeframe(.Year),
        SolvesFromTimeframe(.All)
    ]
  //  * New way below :) */
   // var solvesByTimeFrame: SolvesFromTimeframe = SolvesFromTimeframe(); // initiates an empty solves by timeframe object
 
    //var container: NSPersistentContainer
    @Published var currentTimeframe: Timeframe = .Today  // the current timeframe selected by the bottom bar
    
    init() {
        solves = []
        
        // setup for CoreData
        let solveRequest = NSFetchRequest<SolveItem>(entityName: "SolveItem")
        solveRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            let results = try PersistenceController.shared.container.viewContext.fetch(solveRequest)
            
            //print("worked fetched: ", results)
            for (index, re) in results.enumerated() {
                print("Item \(index) = ", re.timeMS);
                //print("Item as SolveItem = ", re as SolveItem)
                
                self.add(re as SolveItem)
            }
           
            updateDisplay()
            
        }catch  {
            print("error fetching solves: ")
        }
            
        //print("Solves: ", fetchedSolves)
        
        
    }
    
    /*
     *  Updates the last 3 display preview via self.last3
     *  Called by self.updateDisplay & self.updateTimeFrames()
     */
    func updateLast3() {
        //let orderedSolves = solves.sorted(by:{ $0.timeMS < $1.timeMS })
        if timer != nil {
            self.timer.objectWillChange.send()
        }
        if size > 2 {
            self.last3 = [solves[size - 1], solves[size - 2], solves[size - 3]]
        }else if size <= 2 {
            self.last3 = []
            for s in solves {
                self.last3.append(s)
            }
        }
    }
    
    /*
     *  returns whether the provided .TimeFrame has any values in it
     *  Called by StatsBarView.visibility
     
     *  THIS WILL NEED TO BE UPDATED
     */
    func isTimeframeNil(_ tf: Timeframe) -> Bool {
        switch tf {
        case .LastThree:
            if solvesByTimeframe[0].size > 1 {
                return false
            }
        case .Today:
            if solvesByTimeframe[1].size > 1 {
                return false
            }
        case .OneMonth:
            if solvesByTimeframe[2].size > 1 {
                return false
            }
        case .ThreeMonths:
            if solvesByTimeframe[3].size > 1 {
                return false
            }
        case .Year:
            if solvesByTimeframe[4].size > 1 {
                return false
            }
        case .All:
            if solvesByTimeframe[5].size > 1 {
                return false
            }
        default:
            if solvesByTimeframe[1].size > 1 {
                return false
            }
        }
        return true
    }
    
    /*
     *  Updated every solvesByTimeFrame by replacing contents with self.getSolvesFrom(timeframe: .TimeFrame)
     *  Called when a solve is added or deleted via self.delete() & self.updateDisplay()
     
     *  NEEDS TO BE REPLACED, change so that it only needs to update 1 solvesByTimeFrame object
     */
    func updateTimeframes() {
        for (index, tf) in solvesByTimeframe.enumerated() {
            switch(index) {
            
            case 0: // last 3
                
                updateLast3()
                self.solvesByTimeframe[index].replaceWith(last3)
                
                break
            case 1:     // one day
                
                self.solvesByTimeframe[index].replaceWith(self.getSolvesFrom(timeframe: .Today))
                
                break
            case 2:     // one month
                
                self.solvesByTimeframe[index].replaceWith(self.getSolvesFrom(timeframe: .OneMonth))
                
                break
            case 3:
                self.solvesByTimeframe[index].replaceWith(self.getSolvesFrom(timeframe: .ThreeMonths))
                break
            case 4:
                self.solvesByTimeframe[index].replaceWith(self.getSolvesFrom(timeframe: .Year))
                break
            case 5:
                self.solvesByTimeframe[index].replaceWith(self.getSolvesFrom(timeframe: .All))
                break
            default:
                self.solvesByTimeframe[index].replaceWith(self.getSolvesFrom(timeframe: .Today))
                break
            
            }
        }
    }
    
    /*
     *  Returns an array of the solves from the requested timeframe
     *  Called by self.updateTimeFrame
     
     *  NEED TO UPDATE: make i tso it just gets the data from the solvesByTimeFrame object
     */
    func getSolvesFrom(timeframe: Timeframe) -> [SolveItem] {
        var res: [SolveItem] = []
        let now = Date()
        switch timeframe {
        case .LastThree:
            if solves.count >= 3 {
                res = last3
            }
        case .Today:
            for s in solves {
                if Calendar.current.isDateInToday(s.timestamp) {
                    res.append(s)
                }
            }
        case .OneMonth:
            
            let monthAgo: Date = Calendar.current.date(byAdding: .month, value: -1, to: now)!
            let range = monthAgo...now
            for s in solves {
                if range.contains(s.timestamp) {
                    res.append(s)
                }
            }
            
        case .ThreeMonths:
            let threeMonthAgo: Date = Calendar.current.date(byAdding: .month, value: -3, to: now)!
            let range = threeMonthAgo...now
            for s in solves {
                if range.contains(s.timestamp) {
                    res.append(s)
                }
            }
        case .Year:
            let yearAgo: Date = Calendar.current.date(byAdding: .year, value: -1, to: now)!
            let range = yearAgo...now
            for s in solves {
                if range.contains(s.timestamp) {
                    res.append(s)
                }
            }
        case .All:
            res = solves
        default:
            print("fuck")
        }
        return res
    }
    
    /*
     *  Returns an array of all the solves from the current day
     *  IDK about the callers
     *  made redudant by the method above
     
    func getTodaySolves() -> [SolveItem] {
        var res: [SolveItem] = []
        for s in solves {
            if Calendar.current.isDateInToday(s.timestamp) {
                res.append(s)
            }
        }
        return res
    }
     */
    
    
    /*
     *  Deleted a solveItem, returns false if was not able to
     */
    func delete(_ s: SolveItem) -> Bool{
        let deleteIndex = getIndexOf(s)
        if deleteIndex != -1 {
            
            
            PersistenceController.shared.container.viewContext.delete(s)
            
            do {
                try PersistenceController.shared.container.viewContext.save()
                print("Deleted")
                solves = solves.filter { $0 != s }
                size -= 1
                updateDisplay()
            } catch {
                print("error deleting solve")
            }
            updateTimeframes()
            
            
            return true
        }
        return false
    }
    
    /*
     *  Calls all the methods to update the dispaly.
     */
    public func updateDisplay(){
        print("updating display, size = ", size)
        print("updating display, solve count = ", solves.count)
        updateBest()
        updateLast3()
        updateAverage()
        updateTimeframes()
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
     *  Adds a solve to the solve array then calls self.updateDisplay()
     *  Called by TimerController().stopTimer()
     */
    func add(_ s: SolveItem) {
        
        //let newSolve = SolveItem()
        
        size += 1
        print("added: ", s.timeMS)
        solves.append(s)
        updateDisplay()
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
    
    
}

