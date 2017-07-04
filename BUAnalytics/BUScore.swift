//
//  BUScore.swift
//  Example
//
//  Created by Victor on 04/07/2017.
//  Copyright © 2017 Vmlweb. All rights reserved.
//

import Foundation

public class BUScore: BUTemplate{
    
    public var collection: String?
    
    public var value: Int?
    public var highest: Bool?

    public init(value: Int, collection: String? = nil) {
        super.init()
        self.value = value
        self.collection = collection
    }
    
    public func upload(){
        
        //Add optional fields
        if let val = value{ append("value", value: val) }
        if let val = highest{ append("highest", value: val) }
        
        super.upload(collection: collection ?? "Scores")
    }
}
