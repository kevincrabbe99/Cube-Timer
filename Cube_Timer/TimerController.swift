//
//  TimerController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import Foundation
import SwiftUI

class TimerController: ObservableObject {
    
    @Published var  type: ConfigType = .a3x3x3
    @Published var  brand: ConfigBrand = .rubiks
    
    var leftActivated: Bool = false
    var rightActivated: Bool = true
    
    var acceptInput: Bool = true
    
    @Published var startApproved: Bool = false
    @Published var oneActivated: Bool = false
    
    @Published var timerGoing: Bool = false
    var timerALLMS:Double = 0
    var timer: Timer?
    
    var startTime: Double = 0
    var time: Double = 0
    var lastRecordedTime:Double = 0
    var elapsed: Double = 0
    
    @Published var lblMin: String = "00"
    @Published var lblSec: String = "00"
    @Published var lblMS: String = "00"
    
    @Published var solveHandler: SolveHandler = SolveHandler()
    
    init() {
        }
    
    @objc func UpdateTimer() {
        
       // timerALLMS += 1
        lastRecordedTime = Date().timeIntervalSinceReferenceDate - startTime
        time = lastRecordedTime
        
        // calculate min
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // calculate sec
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        // calculate ms
        let milliseconds = UInt8(time * 100)
        
        let strMin = String(format: "%02d", minutes)
        let srtSec = String(format: "%02d", seconds)
        let srcMS = String(format: "%02d",milliseconds)
        
        self.lblMin = strMin
        self.lblSec = srtSec
        self.lblMS = srcMS
    }
    
    func activateRight() {
        print("Right Activated")
        rightActivated = true
        testStart()
    }
    
    func deActivateRight() {
        print("Right DeActivated")
        rightActivated = false
        testStart()
    }
    
    func activateLeft() {
        print("Left Activated")
        leftActivated = true
        testStart()
    }
    
    func deActivateLeft() {
        print("Left DeActivated")
        leftActivated = false
        testStart()
    }
    
    private func testStart() {
        if !acceptInput {
            return
        }
        if leftActivated && rightActivated {
            if timerGoing {
                stopTimer()
            }else {
                startApproved = true
            }
        }else {
            if leftActivated || rightActivated {
                oneActivated = true
                if timerGoing {
                    stopTimer()
                }
            }else {
                oneActivated = false
            }
            if startApproved {
                startTimer()
            }
            startApproved = false
        }
    }
    
    func startTimer() {
        
        UIApplication.shared.isIdleTimerDisabled = true // disable the sleep
        print("time started")
        startTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        timerGoing = true
        
    }
    
    func stopTimer() {
        UIApplication.shared.isIdleTimerDisabled = false // enable the sleep
        print("time stopped")
        
        let newSolve = Solve(type: type, brand: brand, timeMS: lastRecordedTime)
        solveHandler.add(newSolve)
        
        startTime = 0
        oneActivated = false
        timer?.invalidate()
        timerGoing = false
        acceptInput = false
        let delayInputTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(acceptInputNow), userInfo: nil, repeats: false)
    }
    
    @objc func acceptInputNow() {
        acceptInput = true
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
