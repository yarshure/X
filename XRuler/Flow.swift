//
//  Flow.swift
//  XProxy
//
//  Created by yarshure on 2017/11/23.
//  Copyright © 2017年 yarshure. All rights reserved.
//

import Foundation

public struct SFTraffic:Codable {
    public var rx: UInt = 0
    public var tx: UInt = 0
    public init(){
        
    }
    public mutating func addRx(x:Int){
        rx += UInt(x)
    }
    public mutating func addTx(x:Int){
        tx += UInt(x)
    }
    //new api
    public mutating func addFlow(x:Int,RX:Bool){
        if RX {
             rx += UInt(x)
        }else {
            tx += UInt(x)
        }
    }
    public mutating func reset() {
        rx = 0
        tx = 0
    }
    public func txString() ->String{
        return toString(x: tx,label: "TX:",speed: false)
    }
    public func rxString() ->String {
        return toString(x: rx,label:"RX:",speed: false)
    }
    public func toString(x:UInt,label:String,speed:Bool) ->String {
        
        var s = "/s"
        if !speed {
            s = ""
        }
        #if os(macOS)
            if x < 1024{
                return label + " \(x) B" + s
            }else if x >= 1024 && x < 1024*1024 {
                return label +  String(format: "%d KB", Int(Float(x)/1024.0))  + s
            }else if x >= 1024*1024 && x < 1024*1024*1024 {
                //return label + "\(x/1024/1024) MB" + s
                return label +  String(format: "%d MB", Int(Float(x)/1024/1024))  + s
            }else {
                //return label + "\(x/1024/1024/1024) GB" + s
                return label +  String(format: "%d GB", Int(Float(x)/1024/1024/1024))  + s
            }
        #else
            if x < 1024{
                return label + " \(x) B" + s
            }else if x >= 1024 && x < 1024*1024 {
                return label +  String(format: "%.2f KB", Float(x)/1024.0)  + s
            }else if x >= 1024*1024 && x < 1024*1024*1024 {
                //return label + "\(x/1024/1024) MB" + s
                return label +  String(format: "%.2f MB", Float(x)/1024/1024)  + s
            }else {
                //return label + "\(x/1024/1024/1024) GB" + s
                return label +  String(format: "%.2f GB", Float(x)/1024/1024/1024)  + s
            }
        #endif
    }
    public func report() ->String{
        return "\(toString(x: tx, label: "TX:",speed: true)) \(toString(x: rx, label: "RX:",speed: true))"
    }
    public func reportTraffic() ->String{
        return "\(toString(x: tx, label: "TX:",speed: false)) \(toString(x: rx, label: "RX:",speed: false))"
    }
    public func resp ()-> [String:NSNumber] {
        return ["rx":NSNumber.init(value: rx) ,"tx":NSNumber.init(value: tx)]
    }
//    public mutating func mapObject(j:JSON)  {
//        rx = UInt(j["rx"].int64Value)
//        tx = UInt(j["tx"].int64Value)
//    }
}

public enum FlowType:Int {
    case total = 1
    case current = 2
    case last = 3
    case max = 4
    case wifi = 5
    case cell = 6
    case direct = 7
    case proxy = 8
}
public  struct NetFlow:Codable{
    //public static let shared = NetFlow()
    public var totalFlows:[SFTraffic] = []
    public var currentFlows:[SFTraffic] = []
    public var lastFlows:[SFTraffic] = []
    public var maxFlows:[SFTraffic] = []
    
    public var wifiFlows:[SFTraffic] = []
    public var cellFlows:[SFTraffic] = []
    
    public var directFlows:[SFTraffic] = []
    public var proxyFlows:[SFTraffic] = []
    //只保存最近60次采样
    public mutating  func update(_ flow:SFTraffic, type:FlowType){
        var tmp:[SFTraffic]
        switch type {
        case .total:
            tmp = totalFlows
        case .current :
            tmp = currentFlows
        case .last :
            tmp = lastFlows
        case .max:
            tmp = maxFlows
        case .wifi:
            tmp = wifiFlows
        case .cell:
            tmp = cellFlows
        case .direct:
            tmp = directFlows
        case .proxy:
            tmp = proxyFlows
        }
        
        tmp.append(flow)
        if tmp.count > 60 {
            tmp.remove(at: 0)
        }
        //value type write back
        //totalFlows = tmp
        //MARK: todo fix
//        switch type {
//        case .total:
//            totalFlows  = tmp
//        case .current :
//            currentFlows = tmp
//        case .last :
//             lastFlows = tmp
//        case .max:
//            maxFlows = tmp
//        case .wifi:
//              wifiFlows = tmp
//        case .cell:
//             cellFlows = tmp
//        case .direct:
//              directFlows = tmp
//        case .proxy:
//             proxyFlows = tmp
//        }
        
    }
    public func resp() -> [String : AnyObject] {
        var result:[String:AnyObject] = [:]
        var x:[AnyObject] = []
        for xx in totalFlows{
            x.append(xx.resp() as AnyObject)
        }
        result["total"] = x as AnyObject
        return result
    }
//    public func mapObject(j: SwiftyJSON.JSON){
//        totalFlows.removeAll(keepingCapacity: true)
//        for xx in j["total"].arrayValue {
//            var x = SFTraffic()
//            x.mapObject(j: xx)
//            totalFlows.append(x)
//        }
//    }
    public func flow(_ type:FlowType) ->[Double]{
        var r:[Double] = []
        for x in totalFlows {
            r.append(Double(x.rx))
        }
        return r
    }
}
