//
//  SolveHandler.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import Foundation
import CoreData

class SolveHandler: ObservableObject {
    
    @Published var solves: [Solve]
    var size: Int = 0
    
    @Published var average: String = "-1"
    @Published var best: String = "-1"

    var container: NSPersistentContainer
    
    init() {
        solves = []
        print("added: working")
        
        
        container = NSPersistentContainer(name: "Cube_Timer")

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }else {
                print("worked: ", storeDescription)
            }
        }
        
    }
    
    func add(_ s: Solve) {
        
        let newSolve = Solve()
     
        
        print("added: ", s.timeMS)
        solves.append(s)
        updateBest()
        updateAverage()
    }
    
    func updateBest() {
        var b: Double = 1000000000000000
        for s in solves {
            if s.timeMS < b {
                b = s.timeMS
            }
        }
        self.best = convertTime(ms: b)
    }
    
    func updateAverage()  {
        var total:Double = 0
        for s in solves {
            total += s.timeMS
        }
        average =  convertTime(ms: (total / Double(solves.count)))
    }
    
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
    
}
