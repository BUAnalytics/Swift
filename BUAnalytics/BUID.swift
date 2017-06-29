//
//  BUID.swift
//  Example
//
//  Created by Victor on 29/06/2017.
//  Copyright © 2017 Vmlweb. All rights reserved.
//

import Foundation

public class BUID {
    
    var timer: Timer?
    
    //Singleton
    public static let instance = BUID()
    private init(){}
    
    //Store identifiers
    private var identifiers = [String]()
    
    //Check whether identifiers exist
    public var isReady: Bool{ get{ return identifiers.count > 0 } }
    
    //Upload timer interval
    public var interval = 2000.0
    public var size = 100
    
    //Return first id in cache list and remove
    public func generate() -> String{
    
        //Check whether identifiers are depleted
        if identifiers.count <= 0{
        
            //Log error
            print("[BUAnalytics] Identifier cache has been depleted, please adjust your BUID cache size or interval")
        
            //Generate backup identifier
            return UUID().uuidString
        }
    
        //Grab identifier and remove from cache
        return identifiers.removeFirst()
    }
    
    //Start caching identifiers
    public func start(size: Int = 100){
        self.size = size;
        refreshPerform(timer: nil)
    }
    
    //Push documents in all collections to backend server
    @objc private func refreshPerform(timer: Timer?){
        
        //Only refresh if identifier cache is a quarter empty
        if identifiers.count < ((size / 4) * 3){
            refresh()
        }
        
        //Create timer to refresh every x milliseconds
        if interval > 0{
            Timer.scheduledTimer(timeInterval: interval / 1000.0, target: self, selector: #selector(refreshPerform), userInfo: nil, repeats: false)
        }
    }
    public func refresh(){
        
        //Upload data to server using api request
        let count = size - identifiers.count
        BUAPI.instance.request(withPath: "/projects/collections/documents/ids/\(count)", method: .GET, error: { (code) in
            
            //Log error code
            print("[BUAnalytics] Failed to refresh \(count) identifiers from server with error code \(code)")
            
        }) { (response) in
            
            //Cast and add identifiers from response
            self.identifiers.append(contentsOf: response["ids"] as! [String])
        }
    }
}
