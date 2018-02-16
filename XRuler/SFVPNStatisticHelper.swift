//
//  SFVPNStatisticHelper.swift
//  XRuler
//
//  Created by yarshure on 16/02/2018.
//  Copyright © 2018 yarshure. All rights reserved.
//

import Foundation

public final class SFVPNStatisticHelper {
    public static let shared = SFVPNStatisticHelper()
    fileprivate let reportTimer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: DispatchQueue.main)
    public var statistic:SFStatistics = SFStatistics()
    
    init() {
        
        installTimer()
    }
    
    public func startReporting(){
        XRuler.log("Starting reportTimer ..", level: .Info)
        
        reportTimer.resume()
    }
    func installTimer(){
        reportTimer.schedule(deadline: .now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.seconds(1))
        reportTimer.setEventHandler {
            [weak self] in
            
            self?.statistic.reportTask()
        }
        reportTimer.setCancelHandler {
            XRuler.log("cancel reportTimer ..", level: .Info)
        }
    }
    public func pauseReporting(){
        //reportTimer.
        reportTimer.suspend()
    }
    public func cancelReporting(){
        reportTimer.cancel()
    }
    public func flowData(memory:UInt64) ->Data{
        return statistic.flowData(memory: memory)
    }
    public func updateFlow(count:Int,tx:Bool){
        if tx {
            statistic.currentTraffice.addTx(x: count)
        }else {
            statistic.currentTraffice.addRx(x: count)
        }
    }
}