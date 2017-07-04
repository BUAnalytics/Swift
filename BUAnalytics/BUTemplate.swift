//
//  BUTemplate.swift
//  Example
//
//  Created by Victor on 04/07/2017.
//  Copyright © 2017 Vmlweb. All rights reserved.
//

import Foundation

public class BUTemplate: BUDocument{
    
    public var userId: String? = BUUser.current?.userId
    public var sessionId: String? = BUSession.current?.sessionId
    
    public func upload(collection: String){
        
        //Add optional linking fields
        if let val = userId{ self.append("userId", value: val) }
        if let val = sessionId{ self.append("sessionId", value: val) }
        
        //Add to collection manager
        BUCollectionManager.instance.append(collection: collection, document: self)
    }
}
