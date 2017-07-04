//
//  BUQuestion.swift
//  Example
//
//  Created by Victor on 04/07/2017.
//  Copyright © 2017 Vmlweb. All rights reserved.
//

import Foundation

public class BUQuestion: BUTemplate{
    
    public var collection: String?
    
    public var started = Date().timeIntervalSince1970
    public var ended: Double?
    
    public var name: String?
    public var question: String?
    public var answer: String?
    public var correct: Bool?
    
    public init(name: String, collection: String? = nil) {
        super.init()
        self.name = name
        self.collection = collection
    }
    
    public func ask(question: String){
        self.question = question
        started = Date().timeIntervalSince1970
    }
    
    public func answer(_ answer: String, correct: Bool? = nil){
        self.answer = answer
        self.correct = correct
        ended = Date().timeIntervalSince1970
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
        if let val = name{ self.append("name", value: val) }
        if let val = question{ self.append("question", value: val) }
        if let val = answer{ self.append("answer", value: val) }
        if let val = correct{ self.append("correct", value: val) }
        
        super.upload(collection: collection ?? "Questions")
    }
}
