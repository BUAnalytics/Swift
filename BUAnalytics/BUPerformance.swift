//
//  BUPerformance.swift
//  Example
//
//  Created by Victor on 04/07/2017.
//  Copyright © 2017 Vmlweb. All rights reserved.
//

import Foundation

public class BUPerformance: BUTemplate{
    
    public var collection: String?
    
    public var started = CFAbsoluteTimeGetCurrent()
    public var ended: Double?
    
    public var name: String?
    
    public init(name: String, collection: String? = nil) {
        super.init()
        self.name = name
        self.collection = collection
    }
    
    public func start(){
        started = CFAbsoluteTimeGetCurrent()
    }
    
    public func end(){
        ended = CFAbsoluteTimeGetCurrent()
    }
    
    public func upload(){
        
        //Add required fields
        self.append([
            "started": started,
            "ended": ended ?? CFAbsoluteTimeGetCurrent(),
            "length": (ended ?? CFAbsoluteTimeGetCurrent()) - started
        ])
        
        //Add optional fields
        if let val = name{ append("name", value: val) }
        
        super.upload(collection: collection ?? "Performance")
    }
}
