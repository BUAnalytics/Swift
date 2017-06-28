//
//  BGUtility.swift
//  Example
//
//  Created by Victor on 20/12/2016.
//  Copyright © 2016 Vmlweb. All rights reserved.
//

import Cocoa

public class Utility{
    
    public static var userId: String?
    
    //Create new identifier string
    public static func newID() -> String{
        return UUID().uuidString
    }
    
    //Create MD5 hash from input string
    public static func md5(input: String) -> String{
        guard let messageData = input.data(using:String.Encoding.utf8) else { return "" }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    //Generate random number between doubles
    public static func randomDoubleBetween(first: Double, second: Double) -> Double{
        return Double(CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(CGFloat(first) - CGFloat(second)) + min(CGFloat(first), CGFloat(second)))
    }

}

class ReplacePresentationAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    @available(OSX 10.10, *)
    public func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        if let window = fromViewController.view.window {
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                fromViewController.view.animator().alphaValue = 0
            }, completionHandler: { () -> Void in
                viewController.view.alphaValue = 0
                window.contentViewController = viewController
                viewController.view.animator().alphaValue = 1.0
            })
        }
    }

    @available(OSX 10.10, *)
    public func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        if let window = viewController.view.window {
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                viewController.view.animator().alphaValue = 0
            }, completionHandler: { () -> Void in
                fromViewController.view.alphaValue = 0
                window.contentViewController = fromViewController
                fromViewController.view.animator().alphaValue = 1.0
            })
        }
    }

    func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        if let window = fromViewController.view.window {
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                fromViewController.view.animator().alphaValue = 0
            }, completionHandler: { () -> Void in
                viewController.view.alphaValue = 0
                window.contentViewController = viewController
                viewController.view.animator().alphaValue = 1.0
            })
        }
    }
    
    func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        if let window = viewController.view.window {
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                viewController.view.animator().alphaValue = 0
            }, completionHandler: { () -> Void in
                fromViewController.view.alphaValue = 0
                window.contentViewController = fromViewController
                fromViewController.view.animator().alphaValue = 1.0
            })
        }
    }
}
