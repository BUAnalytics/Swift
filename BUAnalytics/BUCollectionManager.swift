//
//  BUCollectionManager.swift
//  Example
//
//  Created by Victor on 20/12/2016.
//  Copyright © 2016 Vmlweb. All rights reserved.
//

import Foundation

public class BUCollectionManager {
    
    var timer: Timer?
    
    //Singleton
    public static let instance = BUCollectionManager()
    private init(){ uploadAllPerform(timer: nil) }
    
    //Store collections
    public var collections = [String: BUCollection]()
    
    //Upload timer interval
    public var interval = 2000.0

    //Events
    public var error: ((BUCollection, BUError) -> Void)?
    public var success: ((BUCollection, Int) -> Void)?
    
    //Create collections from array of name
    public func create(names: [String]){
        for name in names where !collections.keys.contains(name){
            
            //Create new collection if name doesnt exist
            collections[name] = BUCollection(name: name)
        }
    }
    
    //Convenience method for adding a document to a collection and creating the collection if non-existant
    public func append(collection: String, document: Dictionary<String, Any>){
        self.append(collection: collection, document: BUDocument(contents: document))
    }
    public func append(collection: String, document: BUDocument){
        
        //Check whether document exists and create
        if collections[collection] === nil{
            collections[collection] = BUCollection(name: collection)
        }
        
        //Add document to collection
        collections[collection]!.append(document: document)
    }
    
    //Push documents in all collections to backend server
    @objc private func uploadAllPerform(timer: Timer?){
        self.uploadAll()
        
        //Create timer to push all collections every x milliseconds
        if interval > 0{
            Timer.scheduledTimer(timeInterval: interval / 1000.0, target: self, selector: #selector(uploadAllPerform), userInfo: nil, repeats: false)
        }
    }
    public func uploadAll(){
        
        //Push all collections
        for (_, collection) in collections{
            collection.upload(error: { (code) in
                
                //Notify error
                if let error = self.error{
                    error(collection, code)
                }
                
            }, success: { (count) in
                
                //Notify success
                if let success = self.success{
                    success(collection, count)
                }
            })
        }
    }
}
