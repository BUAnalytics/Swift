//
//  MenuViewController.swift
//  Example
//
//  Created by Victor on 20/12/2016.
//  Copyright © 2016 Vmlweb. All rights reserved.
//

import Cocoa

public enum Gender: Int{
    case Male = 0
    case Female = 1
}

class MenuViewController: NSViewController {

    @IBOutlet var startButton: NSButton!
    @IBOutlet var nameField: NSTextField!
    @IBOutlet var ageField: NSTextField!
    @IBOutlet var genderSelect: NSSegmentedControl!
    
    override func viewDidLoad() {
        
        //Set backend api url and authentication details
        BUAPI.instance.auth = BUAccessKey("58ac40d0126553000c426f92", secret: "9a48ab9ac420c0b7f0ed477bb7f56b267477bb808b5ec4d2dddb7e39a57e6f4a")
        //BUAPI.instance.url = "https://192.168.0.69"; //Defaults to https://bu-games.bmth.ac.uk
        
        //Start loading a cache of 200 unique identifiers from backend
        BUID.instance.start(size: 200)
        
        //Create collections with names
        BUCollectionManager.instance.create(names: [
            "Users",
            "Sessions",
            "Clicks"
        ])
        
        //Subscribe to collection errors
        BUCollectionManager.instance.error = { (collection, code) in
            print("[BUAnalytics][\(collection.name)] Failed to upload with error code \(code.rawValue)")
        }
        
        //Subscribe to collection uploads
        BUCollectionManager.instance.success = { (collection, count) in
            print("[BUAnalytics][\(collection.name)] Successfully uploaded \(count) documents")
        }
        
        //Configure collection upload interval
        BUCollectionManager.instance.interval = 4000
        BUID.instance.interval = 4000
    }
    
    @IBAction func startCountdownTimer(_ sender: Any) {
        if startButton.title == "Play!"{
            
            //Check the name field as been filled
            if nameField.stringValue.characters.count <= 0{
                let alert = NSAlert()
                alert.messageText = "Please enter a valid name"
                alert.runModal()
                return
            }
            
            //Check age field has been filled and is numeric
            var age: Int
            if let num = Int(ageField.stringValue), ageField.stringValue.characters.count > 0{
                age = num
            }else{
                let alert = NSAlert()
                alert.messageText = "Please enter a valid age"
                alert.runModal()
                return
            }
            
            //Convert gender to Enum
            var gender: Gender
            if let gend = Gender(rawValue: genderSelect.selectedSegment){
                gender = gend
            }else{
                let alert = NSAlert()
                alert.messageText = "Please select a gender"
                alert.runModal()
                return
            }
            
            //Generate user id hash from two unique bits of information
            if Utility.userId == nil{
                Utility.userId = BUID.instance.generate()
            }
            
            //Create new user in collection
            let userDoc = BUDocument(contents: [
                "userId": Utility.userId as Any,
                "name": nameField.stringValue,
                "age": age,
                "gender": gender.rawValue,
                "device": [
                    "type": "Desktop",
                    "name": Host.current().localizedName,
                    "model": Sysctl.model
                ]
            ])
            
            //Add documents to collections
            BUCollectionManager.instance.collections["Users"]!.append(document: userDoc)
            
            //Start countdown timer
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.stepCountdownTimer(timer:)), userInfo: nil, repeats: true)
            
            //Update interface
            startButton.title = "3"
            NSApplication.shared().mainWindow!.makeFirstResponder(nil)
        }
    }
    
    func stepCountdownTimer(timer: Timer){
        if startButton.title == "3"{
            startButton.title = "2"
        }else if startButton.title == "2"{
            startButton.title = "1"
        }else if startButton.title == "1"{
            
            //Present game view
            let view = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "GameView")
            self.presentViewController(view as! NSViewController, animator: ReplacePresentationAnimator())
            
            //Reset interface
            startButton.title = "Play!"
            nameField.stringValue = ""
            ageField.stringValue = ""
            genderSelect.selectedSegment = -1
        }
    }
}

