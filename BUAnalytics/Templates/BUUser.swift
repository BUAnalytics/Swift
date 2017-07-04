//
//  BUUser.swift
//  Example
//
//  Created by Victor on 04/07/2017.
//  Copyright © 2017 Vmlweb. All rights reserved.
//

import Foundation

public enum BUUserGender{
    case Male
    case Female
}

public class BUUser: BUDocument{
    
    public var collection: String?
    
    public static var current: BUUser?
    
    public var userId = BUID.instance.generate()
    
    public var username: String?
    public var name: String?
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var phone: String?
    public var age: Int?
    public var gender: BUUserGender?
    
    public init(collection: String) {
        super.init()
        self.collection = collection
    }
    
    public func upload(){
        
        //Add required fields
        self.append("userId", value: userId)
        
        //Add optional fields
        if let val = username{ append("username", value: val) }
        if let val = name{ append("name", value: val) }
        if let val = firstName{ append("first_name", value: val) }
        if let val = lastName{ append("last_name", value: val) }
        if let val = email{ append("email", value: val) }
        if let val = phone{ append("phone", value: val) }
        if let val = age{ append("age", value: val) }
        if let val = gender{ append("gender", value: val) }
        
        //Add to collection manager
        BUCollectionManager.instance.append(collection: collection ?? "Users", document: self)
        
        //Remove current if self
        if BUUser.current === self{
            BUUser.current = nil
        }
    }
}
