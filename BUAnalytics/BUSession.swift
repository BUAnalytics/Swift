//
//  BUSession.swift
//  Example
//
//  Created by Victor on 04/07/2017.
//  Copyright © 2017 Vmlweb. All rights reserved.
//

import Foundation

public class BUSession: BUDocument{
    
    public var collection: String?
    
    public static var current: BUSession?
    
    public var sessionId = BUID.instance.generate()
    public var userId: String? = BUUser.current?.userId
    
    public var started = Date().timeIntervalSince1970
    public var ended: Double?
    
    public var ip: String?
    public var device: String?
    public var system: String?
    public var version: String?
    
    public init(collection: String) {
        super.init()
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
            "sessionId": sessionId,
            "started": started,
            "ended": ended ?? Date().timeIntervalSince1970,
            "length": (ended ?? Date().timeIntervalSince1970) - started
        ])
        
        //Add optional fields
        if let val = userId{ append("userId", value: val) }
        if let val = ip{ append("ip", value: val) }
        if let val = device{ append("device", value: val) }
        if let val = system{ append("system", value: val) }
        if let val = version{ append("version", value: val) }
        
        //Add to collection manager
        BUCollectionManager.instance.append(collection: collection ?? "Sessions", document: BUDocument())
        
        //Remove current if self
        if BUSession.current === self{
            BUSession.current = nil
        }
    }
}
