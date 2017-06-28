//
//  BUCollection.swift
//  Example
//
//  Created by Victor on 20/12/2016.
//  Copyright © 2016 Vmlweb. All rights reserved.
//

import Foundation

public class BUCollection{
    
    public let name: String
    
    init(name: String){
        self.name = name
    }
    
    //Document properties, sending data is moved from documents to buffer
    private var documents = [BUDocument]()
    private var buffer = [BUDocument]()
    
    //Check whether any documents exist and if any are being uploaded
    var isUploading: Bool{ get{ return buffer.count > 0 } }
    var isEmpty: Bool{ get{ return documents.count <= 0 } }
    
    //Add single or multiple documents to collection
    public func append(document: BUDocument){
        self.documents.append(document)
    }
    public func append(documents: [BUDocument]){
        self.documents.append(contentsOf: documents)
    }
    
    //Upload pending documents to backend server
    public func upload(error: ((BUError) -> Void)? = nil, success: ((Int) -> Void)? = nil){
        
        //Make sure there are documents available and is not already uploading
        guard !isUploading && !isEmpty else{ return }
        
        //Move documents to buffer
        buffer.append(contentsOf: documents)
        documents.removeAll()
        
        //Convert documents to objects list
        var objects = [[String: Any]]();
        for document in buffer{
            objects.append(document.contents)
        }
        
        //Upload data to server using api request
        let body = [ "documents": objects ]
        BUAPI.instance.request(withPath: "/projects/collections/\(name)/documents", method: .POST, body: body, error: { (code) in

            //Log error code
            print("[BUGamesLab][\(self.name)] Failed to push \(self.buffer.count) documents to server with error code \(code.rawValue)")
            
            //Move buffer back to documents list
            self.documents.append(contentsOf: self.buffer)
            self.buffer.removeAll()
            
            //Notify error
            if let error = error{
                error(code)
            }
            
        }, success: { (response) in
            
            //Notify
            if let success = success{
                success(self.buffer.count)
            }
            
            //Remove buffer contents
            self.buffer.removeAll()
        })
    }
}
