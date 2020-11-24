//
//  BarGraphController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/23/20.
//

import Foundation
import SwiftUI

/*
 *  Class represents an instance of a bar graph
 *  PARENT: SolveHandler.swift
        Created before initialized
 *  HOLDS: the bar views and the bar controllers
 */
class BarGraphController: ObservableObject {
    
    var id: String = UUID().uuidString
    var solveHandler: SolveHandler!
    
    // array of SingleStatBar objects corresponding to this timeframe
    @Published var bars: [SingleStatBar] = [SingleStatBar](repeating: SingleStatBar(), count: 30)
    /* array of SingleStatBarController objects corresponding to the array above
     * get initiated in self.init() */
    var barControllers: [SingleStatBarController] = [SingleStatBarController](repeating: SingleStatBarController(), count: 30)
    
    @Published var highlightedBarIndex: Int = -1
    
    /*
     *  Default constructor used as a placeholder before self can be initialized with a parent: SolveHandler.swift attribute
     *  CALLED BY: SolveHandler.swift (before initialized)
     */
    init() {
        self.solveHandler = nil // creates a "nil" instance in place of SolveHandler (a fake self.parent)
    }
    
    init(parent: SolveHandler) {
        
        self.solveHandler = parent
        
        // fill self.bars by generating blank bars
        for (i, _) in self.bars.enumerated() {  // loop through SingleStatBar view array (self.bars)
            self.bars[i] = SingleStatBar(pct: 0.1)
        }
        
        // fill self.barControllers based on self.bars
        for (i, v) in self.bars.enumerated() { // loop through SingleStatBar view array (self.bars)
            self.barControllers[i] = v.SSBController // assign v.controller to the array spot
            print("Iteration: ", i, " ID: ", self.barControllers[i].id)
        }
        
    }
    
    /*
     *  Animates the bars to 0
     */
    func animateOut() {
        for bar in self.barControllers {
            bar.set(pct: 0)
        }
    }
    func animateIn() {
        updateBars()
    }
    
    /*
     *  Sets self.solves to an array of SingleStatBar objects corresponding to this timeframe
     *  CALLED BY: self.updateDisplay()
     
     *  THIS WAS MOVED FROM SolvesFromTimeframe.swift to (this) SolveHandler.swift
     */
    let numOfBars: Int = 30
    var heightArray = [[SolveItem]](repeating: [], count: 30) // gets accessed in heightArray & highlightLastSolvesBar
    func updateBars()  {
        
        //print("Running: SolveHandler().updateBars()")
        print("updating bars solve count = ", solveHandler.size)
        
        if solveHandler.size < 1 {   // EXIT if there are no solves
            return
        }
        
        unhighlightAll() // unhighlight all the bars ( basically a reset )
        
        let orderedSolves = solveHandler.solves.sorted(by:{ $0.timeMS < $1.timeMS })
        
        let singleBarRepresentation: Double = solveHandler.getRange() / Double(numOfBars)
        
        heightArray = [[SolveItem]](repeating: [], count: numOfBars) // reset the height array
        var barIntervals = [Double](repeating: -1, count: numOfBars)
        
        for i in 0...numOfBars - 1 { // fills the barInterval array with solvetimes
            barIntervals[i] = (solveHandler.getMin().timeMS /* +c is the minimum solve time */ ) + singleBarRepresentation * Double(i)
        }
        
        // place the solveItems in the corresponding heightArray index
        var currentBar: Int = 0
        for s in orderedSolves {
            let ms = s.timeMS
            if ms < barIntervals[currentBar] {
                heightArray[currentBar].append(s)
            } else {
                while (currentBar < heightArray.count - 1) && (ms > barIntervals[currentBar]){ // guart incase we go over
                    currentBar += 1
                }
                heightArray[currentBar].append(s)
            }
        }
        
        // fill the heightArray with the corresponding solveTimes
        var res: [SingleStatBar] = []
        //var min: Double = getMin().timeMS
        //var range: Double = getRange()
        //et maxheight: CGFloat = CGFloat(getRange())
        
        for (index, height) in heightArray.enumerated() {
            let percentage: Double
            let maxBarCount = getMaxBarHeight(heightArray)
            if maxBarCount == 1 { // if the heighest count is 1
                // make it so that the bar is only 1/3 the height
                percentage = Double(height.count) / (maxBarCount * 3)
            }else if maxBarCount == 2 { // if the heighest count is 2
                // make it so that the bar is only half the height
                percentage = Double(height.count) / (maxBarCount * 2)
            }else { // regular implementation
                percentage = Double(height.count) / maxBarCount
            }
            //let bar: SingleStatBar = SingleStatBar(pct: percentage)
            //print("pct: ", percentage)
            //res.append(bar)
            
            self.barControllers[index].set(pct: percentage)
            
        }
        
        /* set the attributes of self.bars to the new attributes
        
        for (index, oldBar) in self.bars.enumerated() {
            oldBar.setAttributes(pct: res[index].percentage )
        }
         */
        
        /* prints the height array
        print("==================== HEIGHT ARRAY ==================")
        for (index, h) in heightArray.enumerated() {
            print("Bar \(index), which is solves under \(barIntervals[index]) has \(h.count) solves")
        }
         */
        
        
        highlightLastSolvesBar() // highlight the last bar added
        
        // set the result to the self.bars
        //self.bars = res
    }
    
    /*
     *  Returns a double representing the number of solves in the heighest bar
     *  Called by self.updateBars()
     */
    private func getMaxBarHeight(_ ar: [[SolveItem]]) -> Double {
        var maxCount:Double = -1
        for i in ar {
            if i.count > Int(maxCount) {
                maxCount = Double(i.count)
            }
        }
        return maxCount
    }
    
    /*
     *  Updates the dispaly, highlighting the last bar
     */
    private func highlightLastSolvesBar() {
        let lastSolve = solveHandler.getLastSolve() // get the last solve from self.solveHandler
        let barIndex = self.getBarIndexWhichIncludes(solve: lastSolve)  // get the index of the bar with that solve
        
        // highlight the bar
        barControllers[barIndex].highlight(Color.init("green"));
    }
    
    /*
     *  gets the bar index which includes the provided solve item
     */
    private func getBarIndexWhichIncludes(solve: SolveItem) -> Int {
        for (index, barSolves) in heightArray.enumerated() {
            for s in barSolves {
                if s.equals(solve) {
                    return index
                }
            }
        }
        return -1
    }
    
    /*
     * used when reseting the bars
     *  CALLED BY: self.updateBars()
     */
    private func unhighlightAll() {
        for (index, barSolves) in barControllers.enumerated() {
            barControllers[index].unhighlight()
        }
    }
  
    
}
