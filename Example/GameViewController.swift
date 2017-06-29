//
//  GameViewController.swift
//  Example
//
//  Created by Victor on 20/12/2016.
//  Copyright © 2016 Vmlweb. All rights reserved.
//

import Cocoa

class GameViewController: NSViewController {
    
    @IBOutlet var button: NSButton!
    
    var clicksRemaining = 5
    var startTime = 0.0
    var delayTime = 0.0
    var target = CGPoint.zero
    var attempts = [CGPoint]()
    var sessionStart = Date()
    var mousePosition = CGPoint.zero
    
    override func viewDidAppear() {
        
        //Configure mouse events
        if let window = NSApplication.shared().mainWindow{
            window.acceptsMouseMovedEvents = true
            window.makeFirstResponder(self.view)
        }
            
        //Set session start
        sessionStart = Date()
        
        //Generate unique session identifier
        Utility.sessionId = BUID.instance.generate()
        
        self.delayButton()
    }
    
    func delayButton(){
        
        //No more clicks remaining
        if clicksRemaining <= 0{
            
            //Create new session in collection
            let sessionDoc = BUDocument(contents: [
                "sessionId": Utility.sessionId as Any,
                "userId": Utility.userId as Any,
                "start": sessionStart,
                "end": Date()
            ])
            
            //Add documents to collections
            BUCollectionManager.instance.collections["Sessions"]!.append(document: sessionDoc)
            
            //Make sure collections are uploaded incase of closure
            BUCollectionManager.instance.uploadAll()
            
            //Return to menu
            if let presenting = presenting{
                presenting.dismissViewController(self)
            }
            return
        }
        
        //Reset all previous attempts
        attempts.removeAll()
        
        //Hide button from screen
        button.frame.origin = CGPoint(x: -200, y: -200)
        
        //Calculate random delay and wait
        delayTime = Utility.randomDoubleBetween(first: 0.5, second: 4)
        Timer.scheduledTimer(timeInterval: delayTime, target: self, selector: #selector(showButton), userInfo: nil, repeats: false)
    }
    
    func showButton(){
        startTime = CACurrentMediaTime()
        
        //Show button in random position on screen
        target.x = CGFloat(Utility.randomDoubleBetween(first: 0.0, second: Double(self.view.frame.size.width) - 200.0))
        target.y = CGFloat(Utility.randomDoubleBetween(first: 0.0, second: Double(self.view.frame.size.height) - 200.0))
        button.frame.origin = target
    }
    
    @IBAction func missedButton(_ sender: NSView) {
        attempts.append(mousePosition)
    }
    
    @IBAction func clickButton(_ sender: Any) {
        clicksRemaining -= 1
        
        //Calculate speed and accuracy data
        let accuracy = CGPoint(x: abs(target.x + 100 - mousePosition.x), y: abs(target.y + 100 - mousePosition.y))
        let clickTime = CACurrentMediaTime() - startTime
        
        //Create new click and add it to list
        let clickDoc = BUDocument(contents: [
            "sessionId": Utility.sessionId as Any,
            "userId": Utility.userId as Any,
            "clickTime": clickTime,
            "delayTime": delayTime,
            "accuracy": accuracy,
            "target": target,
            "attempts": attempts
        ])
        
        //Add click to collection
        BUCollectionManager.instance.collections["Clicks"]!.append(document: clickDoc)
        
        self.delayButton()
    }
    
    override func mouseMoved(with event: NSEvent) {
        mousePosition = self.view.convert(event.locationInWindow, from: nil)
    }
    
    override var acceptsFirstResponder: Bool{
        return true
    }
    override func becomeFirstResponder() -> Bool {
        return true
    }
}
