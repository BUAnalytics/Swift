//
//  BUDeath.swift
//  Example
//
//  Created by Victor on 04/07/2017.
//  Copyright © 2017 Vmlweb. All rights reserved.
//

import Foundation

public struct BUDeathLocation{
    var x: Int
    var y: Int
    var z: Int?
}

public class BUDeath: BUTemplate{
    
    public var collection: String?
    
    public var location: BUDeathLocation?
    
    public init(location: BUDeathLocation?, collection: String? = nil) {
        super.init()
        self.location = location
        self.collection = collection
    }
    
    public func upload(){
        
        //Add optional fields
        if let val = location{ append("location", value: val) }
        
        super.upload(collection: collection ?? "Deaths")
    }
}
