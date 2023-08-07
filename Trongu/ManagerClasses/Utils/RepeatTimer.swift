//
//  RepeatTimer.swift
//  meetwise
//
//  Created by Nitin Kumar on 23/08/20.
//  Copyright © 2020 Nitin Kumar. All rights reserved.
//

import Foundation


open class RepeatTimer {

    private var countTimer:Timer?
    private var timeInterval:TimeInterval = 0.0
    private var totalTime:TimeInterval = 0.0
    
    var callBackTimer: ((String) -> ())?
    var callBackTimerPerSecond: ((TimeInterval) -> ())?
    var callBackTimerComplete: ((String) -> ())?
    
    
    public init(seconds timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
        self.totalTime = timeInterval
        self.setTimer()
    }
    
    public init(minutes timeInterval: TimeInterval) {
        self.timeInterval = timeInterval * 60
        self.totalTime = timeInterval
        self.setTimer()
    }
    

    func setTimer() {
        print("timer ***** \(timeInterval)")
        self.countTimer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
    }

    func invalidate() {
        self.countTimer?.invalidate()
        self.countTimer = nil
    }

    @objc func runTimedCode(_ timer:Timer) {
        self.timeInterval -= 1
        if self.timeInterval == 0 {
            self.invalidate()
            self.callBackTimer?(timeFormat)
            self.callBackTimerComplete?(timeFormat)
        } else {
            self.callBackTimer?(timeFormat)
            self.callBackTimerPerSecond?(self.totalTime-self.timeInterval)
        }
    }
    
    var timeFormat: String {
//        let hours = Int(time) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
//        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
}
