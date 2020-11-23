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
    @Published var solvesByTimeframe: [SolvesFromTimeframe] = [
        SolvesFromTimeframe(.LastThree),
        SolvesFromTimeframe(.Today),
        SolvesFromTimeframe(.OneMonth),
        SolvesFromTimeframe(.ThreeMonths),
        SolvesFromTimeframe(.Year),
        SolvesFromTimeframe(.All)
    ]
    //var container: NSPersistentContainer
    @Published var currentTimeframe: Timeframe = .Today
    
    init() {
        solves = []
       
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
        
        
        /*
        container = NSPersistentContainer(name: "Cube_Timer")

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }else {
                print("worked: ", storeDescription)
            }
        }
 */
        
    }
    
    /* update last 3 as best 3
    func updateLast3() {
        let orderedSolves = solves.sorted(by:{ $0.timeMS < $1.timeMS })
        if timer != nil {
            self.timer.objectWillChange.send()
        }
        if size > 2 {
            self.last3 = [orderedSolves[0], orderedSolves[1], orderedSolves[2]]
        }else if size <= 2 {
            self.last3 = []
            for s in solves {
                self.last3.append(s)
            }
        }
    }
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
    
    
    func getTodaySolves() -> [SolveItem] {
        var res: [SolveItem] = []
        for s in solves {
            if Calendar.current.isDateInToday(s.timestamp) {
                res.append(s)
            }
        }
        return res
    }
    
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
    
    public func updateDisplay(){
        print("updating display, size = ", size)
        print("updating display, solve count = ", solves.count)
        updateBest()
        updateLast3()
        updateAverage()
        updateTimeframes()
    }
    
    func getIndexOf(_ match: SolveItem) -> Int {
        var i: Int = -1
        for (index, s) in solves.enumerated() {
            if s.equals(match) {
                i = index
            }
        }
        return i
    }
    
    func add(_ s: SolveItem) {
        
        //let newSolve = SolveItem()
        
        
        
        size += 1
        print("added: ", s.timeMS)
        solves.append(s)
        updateDisplay()
    }
    
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
    func convertTime(ms: Double) -> String{
        
        
        var time = ms
        
        // calculate min
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // calculate sec
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        // calculate ms
        let milliseconds = UInt8(time * 100)
        
        let strMin = String(format: "%02d", minutes)
        let strSec = String(format: "%02d", seconds)
        let strMS = String(format: "%02d",milliseconds)
        
        if minutes < 1 {
            return strSec + "." + strMS + " sec"
        }else {
            return strMin + "m " + strSec + "sec"
        }
    }
    */
    
    
}

