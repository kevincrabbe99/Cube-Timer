//
//  AllSolvesController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/25/20.
//

import Foundation

class AllSolvesController: ObservableObject {
    
    var contentView: ContentView!
    var solvesData: SolvesFromTimeframe!
    var cTypeHandler: CTypeHandler!
    
    @Published var best: SolveItem?
    @Published var worst: SolveItem?
    @Published var median: Double = 0
    
    @Published var count: Int?
    @Published var average: Double?
    @Published var stdDev: Double?
    
    @Published var solves: [SolveItem] = []
   // @Published var timeGroupControllers: [TimeGroupController]
    
    @Published var tgControllerToday: TimeGroupController
    @Published var tgControllerYesterday: TimeGroupController
    @Published var tgControllerThisWeek: TimeGroupController
    @Published var tgControllerThisMonth: TimeGroupController
    @Published var tgControllerLastMonth: TimeGroupController
    @Published var tgControllerUnknown: TimeGroupController
    
    @Published var tgControllerJan: TimeGroupController
    @Published var tgControllerFeb: TimeGroupController
    @Published var tgControllerMar: TimeGroupController
    @Published var tgControllerApr: TimeGroupController
    @Published var tgControllerMay: TimeGroupController
    @Published var tgControllerJun: TimeGroupController
    @Published var tgControllerJul: TimeGroupController
    @Published var tgControllerAug: TimeGroupController
    @Published var tgControllerSep: TimeGroupController
    @Published var tgControllerOct: TimeGroupController
    @Published var tgControllerNov: TimeGroupController
    @Published var tgControllerDec: TimeGroupController
    
    
    // selecting mode stuff
    @Published var selecting: Bool = false
    @Published var selected: [SolveElementController] = []
  
    
    init() {
        self.tgControllerToday = TimeGroupController(tg: .today, solves: [])
        self.tgControllerYesterday = TimeGroupController(tg: .yesterday, solves: [])
        self.tgControllerThisWeek = TimeGroupController(tg: .thisWeek, solves: [])
        self.tgControllerThisMonth = TimeGroupController(tg: .thisMonth, solves: [])
        self.tgControllerLastMonth = TimeGroupController(tg: .lastMonth, solves: [])
        self.tgControllerUnknown = TimeGroupController(tg: .Unknown, solves: [])
        
        self.tgControllerJan = TimeGroupController(tg: .jan, solves: [])
        self.tgControllerFeb = TimeGroupController(tg: .feb, solves: [])
        self.tgControllerMar = TimeGroupController(tg: .mar, solves: [])
        self.tgControllerApr = TimeGroupController(tg: .apr, solves: [])
        self.tgControllerMay = TimeGroupController(tg: .may, solves: [])
        self.tgControllerJun = TimeGroupController(tg: .jun, solves: [])
        self.tgControllerJul = TimeGroupController(tg: .jul, solves: [])
        self.tgControllerAug = TimeGroupController(tg: .aug, solves: [])
        self.tgControllerSep = TimeGroupController(tg: .sep, solves: [])
        self.tgControllerOct = TimeGroupController(tg: .oct, solves: [])
        self.tgControllerNov = TimeGroupController(tg: .nov, solves: [])
        self.tgControllerDec = TimeGroupController(tg: .dec, solves: [])
        
        
        self.tgControllerToday.setParent(self)
        self.tgControllerYesterday.setParent(self)
        self.tgControllerThisWeek.setParent(self)
        self.tgControllerThisMonth.setParent(self)
        self.tgControllerLastMonth.setParent(self)
        
        self.tgControllerJan.setParent(self)
        self.tgControllerFeb.setParent(self)
        self.tgControllerMar.setParent(self)
        self.tgControllerApr.setParent(self)
        self.tgControllerMay.setParent(self)
        self.tgControllerJun.setParent(self)
        self.tgControllerJul.setParent(self)
        self.tgControllerAug.setParent(self)
        self.tgControllerSep.setParent(self)
        self.tgControllerOct.setParent(self)
        self.tgControllerNov.setParent(self)
        self.tgControllerDec.setParent(self)
        
    }
    
    
    /*
     * clears the selected array
     */
    public func clearSelected() {
        self.selected = []
    }
    
    public func timeGroupHasSolves(_ tgc: TimeGroupController) -> Bool{
        if tgc.solveElementControllers.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    
    /*
     *  called when a solve is tapped on
     *      this gets called from SolveElementView -> TimeGroupController -> AllSolvesController
     */
    public func tap(_ sec: SolveElementController) {
        print("tapped for selection: ", sec.si.timeMS)
        
        self.selecting = true // set to true just incase
        
        self.selected.append(sec)
    }
    
    public func uptap(_ sec: SolveElementController) {
        
        self.selected = selected.filter { $0 != sec }
        
        if selected.count == 0 {
            self.selecting = false
        }
    }
    
    
    
    /*
     * this is called by CTypeHandler and updates the solves
            * I am modeling this metho after SolveHandler.updateSolves()
     */
    public func updateSolves() {
        self.clearTimeGroups()
        self.solves = solvesData.getSolvesFrom(ct: cTypeHandler.selected!)
        
        print("updating AllSolvesView to: ", cTypeHandler.selected.name)
        print("analyzing ", solves.count, " solves")
        
        // routes the solves to the tg controllers
        for s in solves {
            addSolveToCorrespondingTGController(s: s)
        }
        
        // unselect everything
      // unselectAll() // this goes to all the views and unselects 
        
        // update all attributes
        updateBest()
        updateWorst()
        updateMedian()
        updateCount()
        updateAverage()
        updateStdDev()
    }
    
    
    
    private func updateStdDev() {
        
        var data: [Double] = []
        
        for s in solves {
            data.append(s.timeMS)
        }
        
        let length:Double = Double(data.count)
        let sumOfSquaredAvgDiff = data.map { pow($0 - (self.average ?? 0), 2.0)}.reduce(0, {$0 + $1})
        
        self.stdDev = sqrt(sumOfSquaredAvgDiff / length)
    }
    
    private func updateAverage() {
        var i: Double = 0
        
        for s in solves {
            i += s.timeMS
        }
        
        self.average = i / Double(solves.count)
    }
    
    private func updateCount() {
        self.count = solves.count
    }
    
    private func updateMedian() {
        let c = solves.count
        if c < 4 {
            self.median = 0
            return
        }
        
        if c % 2 == 0 { // if even
            let s1 = solves[c/2]
            let s2 = solves[(c/2)+1]
            let sum = s1.timeMS + s2.timeMS
            self.median = (sum / 2)
        } else { // if odd
            self.median = solves[c/2].timeMS
        }
    }
    
    /*
     *  Finds the worst solve and sets it as best time
     *  Called by self.updateDisplay()
     */
    private func updateWorst() {
        if solves.count == 0 {
            worst = nil
            return
        }
        
        var b: SolveItem = solves[0]
        for s in solves {
            if s.timeMS > b.timeMS {
                b = s
            }
        }
        //self.best = convertTime(ms: b)
        self.worst = b
    }
    
    /*
     *  Finds the best solve and sets it as best time
     *  Called by self.updateDisplay()
     */
    private func updateBest() {
        
        if solves.count == 0 {
            best = nil
            return
        }
        
        var b: SolveItem = solves[0]
        for s in solves {
            if s.timeMS < b.timeMS {
                b = s
            }
        }
        //self.best = convertTime(ms: b)
        self.best = b
    }
    
    /*
     * called from updateSolves() routs the solves into their corresponding timeGroupController containers
     */
    private func addSolveToCorrespondingTGController(s: SolveItem) {
        
        let tg = s.getTimeGroup()
        
        switch tg {
        case .Unknown:
            self.tgControllerUnknown.add(s: s)
        case .today:
            self.tgControllerToday.add(s: s)
        case .yesterday:
            self.tgControllerYesterday.add(s: s)
        case .thisWeek:
            self.tgControllerThisWeek.add(s: s)
        case .thisMonth:
            self.tgControllerThisMonth.add(s: s)
        case .lastMonth:
            self.tgControllerLastMonth.add(s: s)
        case .jan:
            self.tgControllerJan.add(s: s)
        case .feb:
            self.tgControllerFeb.add(s: s)
        case .mar:
            self.tgControllerMar.add(s: s)
        case .apr:
            self.tgControllerApr.add(s: s)
        case .may:
            self.tgControllerMay.add(s: s)
        case .jun:
            self.tgControllerJun.add(s: s)
        case .jul:
            self.tgControllerJul.add(s: s)
        case .aug:
            self.tgControllerAug.add(s: s)
        case .sep:
            self.tgControllerSep.add(s: s)
        case .oct:
            self.tgControllerOct.add(s: s)
        case .nov:
            self.tgControllerNov.add(s: s)
        case .dec:
            self.tgControllerDec.add(s: s)
        }
        
    }
    
    public func clearTimeGroups() {
        self.tgControllerToday.clearSolves()
        self.tgControllerYesterday.clearSolves()
        self.tgControllerThisWeek.clearSolves()
        self.tgControllerThisMonth.clearSolves()
        self.tgControllerLastMonth.clearSolves()
        self.tgControllerUnknown.clearSolves()
        
        self.tgControllerJan.clearSolves()
        self.tgControllerFeb.clearSolves()
        self.tgControllerMar.clearSolves()
        self.tgControllerApr.clearSolves()
        self.tgControllerMay.clearSolves()
        self.tgControllerJun.clearSolves()
        self.tgControllerJul.clearSolves()
        self.tgControllerAug.clearSolves()
        self.tgControllerSep.clearSolves()
        self.tgControllerOct.clearSolves()
        self.tgControllerNov.clearSolves()
        self.tgControllerDec.clearSolves()
    }
    
    
}
