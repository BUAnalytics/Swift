//
//  BUScreen.swift
//  Example
//
//  Created by Victor on 04/07/2017.
//  Copyright © 2017 Vmlweb. All rights reserved.
//

import Foundation

public class BUScreen: BUTemplate{
    
    public var collection: String?
    
    public var started = Date().timeIntervalSince1970
    public var ended: Double?
    
    public var name: String?
    
    public init(name: String, collection: String? = nil) {
        super.init()
        self.name = name
        self.collection = collection
    }
    
    public func start(){
        started = Date().timeIntervalSince1970
    }
    
    public func end(){
        ended = Date().timeIntervalSince1970
    }
    
    public func upload(){
        
        //Add required fields
        self.append([
            "started": started,
            "ended": ended ?? Date().timeIntervalSince1970,
            "length": (ended ?? Date().timeIntervalSince1970) - started
        ])
        
        //Add optional fields
        if let val = name{ append("name", value: val) }
        
        super.upload(collection: collection ?? "Screens")
    }
}
