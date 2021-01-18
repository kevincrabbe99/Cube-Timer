//
//  TimerController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import Foundation
import SwiftUI
import CoreData
import Firebase
import StoreKit

class TimerController: ObservableObject {
    
    //@Environment(\.managedObjectContext) private var viewContext
   // @Environment (\.presentationMode) var presentationMode
    
    
    //@Published var  type: PuzzleType = .a3x3x3
    //@Published var  brand: PuzzleBrand = .rubiks
    
    var leftActivated: Bool = false
    var rightActivated: Bool = false
    var neitherActivated: Bool = true
    
    var acceptInput: Bool = true // used as a guard for pressing the buttons
    
    @Published var startApproved: Bool = false  // true when all the factors which initail the timer are true
    @Published var oneActivated: Bool = false   // true when one of the buttons is pressed
    @Published var bothActivated: Bool = false
    
    @Published var timerGoing: Bool = false // true when the timer is counting up
    var timer: Timer? // the actual timer
    
    var startTime: Double = 0 // timestamp of when the timer starts
    @Published var time: Double = 0 // the current time displayed
    @Published var lastRecordedTime:Double = 0 // the timestamp of when the timer is canceled
    
    // the labels which are dislpayed
    @Published var lblMin: String = "00"
    @Published var lblSec: String = "00"
    @Published var lblMS: String = "00"
    var minutes: Int = 0
    var seconds: Int = 0
    var milliseconds: Int = 0

    
    @Published var overUnderTime: String = "0s"
    @Published var overUnderPercentage: Double = 0
    @Published var statColor: Color = Color.init("green")
    
    @Published var peripheralOpacity: Double = 1
    
    
    var solveHandler: SolveHandler! // solve handler
    var bo3Controller: BO3Controller!
    var cTypeHandler: CTypeHandler!
    var settingsController: SettingsController!
    var cvc: ContentViewController!
    
    
    init() {
       
        
    }
    
    /*
     * Gets the last solve from solveHandler then displays it
     * Called upon initiation of app
     * CALLED BY: ContentView.init()
     */
    public func setDisplayToLastSolve() {
        // get the last time from solveHandler
        if solveHandler.size > 0  {
            time = solveHandler.getLastSolve()!.timeMS
        }else  {
            time = 0
        }
        
        updateOverUnderDisplay() // update the O/U display
        updateTimerFromTime() // update from just set time
        //bo3Controller.update() // update bo3 view
    }

    
    /*
     *  Updates the stopwatch display based on self.minutes, self.seconds, sellf.miliseconds.
     */
    func updateLabels() {
        let strMin = String(format: "%02d", minutes)
        let srtSec = String(format: "%02d", seconds)
        let srcMS = String(format: "%02d",milliseconds)
        
        self.lblMin = String(strMin.prefix(2))
        self.lblSec = String(srtSec.prefix(2))
        self.lblMS = String(srcMS.prefix(2))
    }
    
    
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    let heavyTap = UIImpactFeedbackGenerator(style: .heavy)
    let startTap = UINotificationFeedbackGenerator()
    
    func activateRight() {
        lightTap.impactOccurred()
        print("Right Activated")
        rightActivated = true
        testStart()
    }
    
    func deActivateRight() {
        print("[timer] Right DeActivated")
        rightActivated = false
        testStart()
    }
    
    func activateLeft() {
        lightTap.impactOccurred()
        print("[timer] Left Activated")
        leftActivated = true
        testStart()
    }
    
    func deActivateLeft() {
        print("[timer] Left DeActivated")
        leftActivated = false
        testStart()
    }
    
    private func testStart() {
        
        if acceptInput {
        print("[timer] testStart: called")
            oneActivated = (leftActivated || rightActivated) && !(leftActivated && rightActivated) // bool expression for if one is active
            bothActivated = (leftActivated && rightActivated)
            neitherActivated = !(leftActivated && rightActivated)
            
            
            // if both are activated
            if bothActivated {
                bothButtonsPressed()
            } else if oneActivated { // if one is pressed
                oneButtonPressed()
            } else if neitherActivated { // none are pressed
                neitherPressed()
            }
                
        }
      
    }

    /*
     *  Either stops or starts the timer  START APPROVED PROBLEM!
     */
    private func neitherPressed() {
        //startApproved = false
        self.oneActivated = false
        self.bothActivated = false
        if timerGoing { // stop timer
            //stopTimer()
            //startApproved = false // prevent from starting timer without both buttons pressed
        } else if !startApproved { // dont abort if start is approved
            abortResettingTimer()
        } else if startApproved {
            startTimer()
        }
    }
    /*
     *  Sets self.peripgeralOpacity
     */
    private func oneButtonPressed() {
        //startApproved = false
        //self.peripheralOpacity = 0
        self.oneActivated = true
        self.bothActivated = false
        if !timerGoing { // if timer is not going
            self.resetTimerStart()  // start reseting the timer
        } else {
            // check with settings
            if !settingsController.requireDoublePressToStop {
                stopTimer()
                startApproved = false
            }
        }
    }
    
    private func bothButtonsPressed() {
        self.oneActivated = false
        self.bothActivated = true
        if timerGoing {
            stopTimer()
            startApproved = false
        }else {
            startApproved = true
        }
    }
    
    var tempSolve: SolveItem?
    
    func startTimer() {
        
        // block view from switching
        cvc.blockGesture = true // blocks page transition
        
        self.peripheralOpacity = 0 // show the peripherals
       // solveHandler.barGraphController.animateOut()
        startTap.notificationOccurred(.success) // tap the phone when starting
        
        UIApplication.shared.isIdleTimerDisabled = true // disable the sleep
        print("[timer.startTimer] timerStarted")
        
        // create temp solve object
        if !settingsController.pauseSavingSolves {
            self.tempSolve = SolveItem.init(entity: SolveItem.entity(), insertInto: PersistenceController.shared.container.viewContext)
            tempSolve!.id = UUID().uuidString
            tempSolve!.timeMS = lastRecordedTime
            tempSolve!.timestamp = Date()
            tempSolve!.cubeType = cTypeHandler.selected!
            
            solveHandler.add(tempSolve!, newEntry: true)
        }
        
        startTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        timerGoing = true
        
        acceptInput = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.acceptInput = true
        }
        
        /*
         *  GA: set user property, timer_going
         */
        Analytics.setUserProperty("true", forName: "timer_going")
    }
    
    func stopTimer() {
        
        self.solveHandler.barGraphController.animateIn()
        self.peripheralOpacity = 1 // show the peripherals
        
        
        if !settingsController.pauseSavingSolves {
            do {
                try PersistenceController.shared.container.viewContext.save()
                    print("[timer.stopTimer] Solve Saved!")
                //presentationMode.wrappedValue.dismiss()  //idk
            } catch {
                print("[timer.stopTimer] SAVE ERROR: ", error.localizedDescription)
            }
        }
        
        startTime = 0
        timer?.invalidate()
        self.tempSolve = nil
        oneActivated = false
        bothActivated = false
        timerGoing = false
        acceptInput = false
        //let delayInputTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(acceptInputNow), userInfo: nil, repeats: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.acceptInput = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.cvc.blockGesture = false // allows the page to transition again
        }
        
        
        // request rating after 1.5 seconds
        if (solveHandler.solves.count % 20) == 0 { // only prompt is solve handler countis divisible by 20
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                // find scene and primpt
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    
                    // prompt
                    SKStoreReviewController.requestReview(in: scene)
                    
                }
                
                // google analytics
                Analytics.logEvent("requested_review", parameters: nil)
            }
        }
        
        /*
         *  Google Analytics log new solve
        Analytics.logEvent("time_saved", parameters: [
            "puzzle_name": lastSolve!.cubeType.rawName! as NSObject,
            "puzzle_description": lastSolve!.cubeType.description as NSObject,
            "seconds": lastSolve!.timeMS as NSObject
        ])
         */
        
        
       Analytics.setUserProperty("false", forName: "timer_going")
        
        let lastSolve = solveHandler.getLastSolve()
        Analytics.logEvent(AnalyticsEventPostScore, parameters: [
            AnalyticsParameterItemName: lastSolve!.cubeType.name as NSObject,
            AnalyticsParameterItemBrand: lastSolve!.cubeType.descrip as NSObject,
            AnalyticsParameterScore: lastSolve!.timeMS as NSObject
        ])
    }
    
    @objc func acceptInputNow() {
        acceptInput = true
    }
    
    
    
    
    
    
    
    
    
    /*
     *  This gets called every milisecond
     *  CALLS: self.updateTimerFromTime()
     */
    @objc func UpdateTimer() {
        
        // update vars which control the timer
        lastRecordedTime = Date().timeIntervalSinceReferenceDate - startTime // calculates the new time (every milisecond)
        time = lastRecordedTime
        
        if !settingsController.pauseSavingSolves {
            self.tempSolve!.timeMS = time // update tempSolve 
        }
        
        self.updateOverUnderDisplay() // update O/U display
        self.updateTimerFromTime() // update timer display
        self.solveHandler.barGraphController.updateBars()
        self.bo3Controller.update()
        
    }
    
    /*
     *  Used to update the over/under display
     *  NOTE: must be called after updating SolveHandler.average
     */
    public func updateOverUnderDisplay() {
        // SET: O/U Time
        if solveHandler.average.timeInMS > self.time {
            self.overUnderTime = TimeCapture( solveHandler.average.timeInMS - self.time ).getInSolidForm()
        }else {
            self.overUnderTime = TimeCapture( self.time - solveHandler.average.timeInMS ).getInSolidForm()
        }
        
        // SET: O/U Percentage
        self.overUnderPercentage = (time / solveHandler.average.timeInMS) * 100
        
        // SET: O/U Color
        if solveHandler.average.timeInMS > self.time {
            self.statColor = Color.init("green")
        }else  {
            self.statColor = Color.init("red")
        }
    }
    
    /*
     *  Updates the timer display based on self.time rather than self.lastRecordedTime (used in self.updateTimer())
     *  CALLS: self.updateLabels()
     *  CALLED by: this.updateTimer()
     */
    func updateTimerFromTime(updateDisplay: Bool = true) {
        
        // calculate min
        minutes = Int(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // calculate sec
        seconds = Int(time)
        time -= TimeInterval(seconds)
        
        // calculate ms
        milliseconds = Int(time * 100)
        
        
        
        // calls method below to update the display
        if updateDisplay { // true by default
            self.updateLabels()
        }
    }
    
    
    //var lastTime: Double! = nil
    var abortTimerReset: Bool = false
    let iterations: Int = 20 // amount of times the value will change
    let iterationDelay: Double = 0.02 // initial delay before timeFactor is applies
    let timeFactor: Double = 30 // the higher this number the faster
    private func resetTimerStart() {
        
        abortTimerReset = false // reset abort var
        peripheralOpacity = 0 // hide peripherals
        solveHandler.barGraphController.animateOut() // hide bars
        
        var timeQuotient: Double = 0
        var minQuotient: Double = 0
        var secQuotient: Double = 0
        var milliQuotient: Double = 0
        
        if self.time != 0 {
            timeQuotient = Double(( (time * 100) / Double(iterations))) // divide minutes by iterations
        }
        if self.minutes != 0 {
            minQuotient = Double((minutes / iterations)) // divide minutes by iterations
        }
        if self.seconds != 0 {
            secQuotient = Double((seconds / iterations)) // divide minutes by iterations
        }
        if self.milliseconds != 0 {
            milliQuotient = Double((milliseconds / iterations)) // divide minutes by iterations
        }
        
        // create array with every number wich will be displayed on the way down
        var tQArray: [Double] = []
        var mQArray: [Int] = []
        var sQArray: [Int] = []
        var mlQArray: [Int] = []
        // assign values
        for i in stride(from: (iterations-1), through: 0, by: -1) {
            tQArray.append(timeQuotient * Double(i)) // set total time (effects over/under display
            mQArray.append(Int(minQuotient * Double(i))) // set minutes
            sQArray.append(Int(secQuotient * Double(i))) // set seconds
            mlQArray.append(Int(milliQuotient * Double(i)))  // set milliseconds
        }
        
        for i in 0...(iterations-1) {
            DispatchQueue.main.asyncAfter(deadline: .now() + ((iterationDelay*(1+(Double(i)/timeFactor))) * Double(i))) {
                self.timerResetIteration(tQ: tQArray[i], mQ: mQArray[i], sQ: sQArray[i], mlQ: mlQArray[i])
            }
        }
        
    }
    /*
     * A single iteration of reseting the timer
     */
    private func timerResetIteration(tQ: Double, mQ: Int, sQ: Int, mlQ: Int) {
        if !abortTimerReset {
            self.time = Double(tQ) // sets the overall time var
            self.minutes = mQ // set minutes
            self.seconds = sQ // set seconds
            self.milliseconds = mlQ // set milliseconds
            
        }
        updateOverUnderDisplay() // update the O/U display
        updateLabels() // update just the labels
    }
    
    private func abortResettingTimer() {
        abortTimerReset = true
        peripheralOpacity = 1
        setDisplayToLastSolve()
        solveHandler.barGraphController.animateIn() // hide bars
    }
    
    
}



extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
    
    
    
}
