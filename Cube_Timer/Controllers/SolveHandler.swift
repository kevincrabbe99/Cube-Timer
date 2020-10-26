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
    
    @Published var solves: [SolveItem]
    var size: Int = 0
    
    @Published var average: TimeCapture = TimeCapture()
    @Published var best: TimeCapture = TimeCapture()

    @Published var last3: [SolveItem] = []
    
    //var container: NSPersistentContainer
    
    
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
    
    func updateLast3() {
        if timer != nil {
            self.timer.objectWillChange.send()
        }
        if size > 2 {
            self.last3 = [solves[size-3], solves[size-2], solves[size-1]]
        }else if size <= 2 {
            self.last3 = []
            for s in solves {
                self.last3.append(s)
            }
        }
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
