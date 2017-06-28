//
//  BUDocument.swift
//  Example
//
//  Created by Victor on 20/12/2016.
//  Copyright © 2016 Vmlweb. All rights reserved.
//

import Foundation

public class BUDocument{
    
    public var contents: [String: Any]
    
    public init(){
        self.contents = [:]
    }
    
    public init(contents: [String: Any]){
        self.contents = contents
    }
    
    public func append(_ key: String, value: Any){
        contents[key] = value
    }
}
