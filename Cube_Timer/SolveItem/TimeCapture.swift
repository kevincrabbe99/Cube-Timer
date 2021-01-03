//
//  TimeCapture.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/26/20.
//

import Foundation

struct TimeCapture {
    
    var timeInMS: Double
    
    var minutes: Int
    var seconds: Int
    var milliseconds: Int
    
    var strMinutes: String
    var strSeconds: String
    var strMilliseconds: String
    
    init() {
        timeInMS = -1
        
        minutes = -1
        seconds = -1
        milliseconds = -1
        
        strMinutes = "-"
        strSeconds = "-"
        strMilliseconds = "-"
    }
    
    init(_ ms: Double) {
        var time = ms
        
        self.timeInMS = ms
        // calculate min
        self.minutes = Int(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // calculate sec
        self.seconds = Int(time)
        time -= TimeInterval(seconds)
        
        // calculate ms
        self.milliseconds = Int(time * 100)
        
        self.strMinutes = String(format: "%02d", minutes)
        self.strSeconds = String(format: "%02d", seconds)
        self.strMilliseconds = String(format: "%02d",milliseconds)
      
    }
    
    func getInSolidForm() -> String {
        
        var res: String = ""
        
        if minutes > 0 {
            res.append("\(minutes)m")
        }
        
        res.append(" \(seconds)s")
        
        return res.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func getAsReadable() -> String {
        
        var time = timeInMS
        
        // calculate min
        let minutes = Int(timeInMS / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // calculate sec
        let seconds = Int(time)
        time -= TimeInterval(seconds)
        
        // calculate ms
        let milliseconds = Int(time * 100)
        
        let strMin = String(format: "%2d", minutes)
        let strSec = String(format: "%2d", seconds)
        let strMS = String(format: "%02d",milliseconds)
        
        if minutes == 0 {
            return strSec + "." + strMS + "s"
        }else {
            return (strMin + "m " + strSec + "s")
        }
    }
    
    
    
}
