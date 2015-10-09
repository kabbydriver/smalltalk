//
//  ViewController.swift
//  TestApp
//
//  Created by Kabir Gogia on 9/7/15.
//  Copyright (c) 2015 Kabir. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate, MPCManagerDelegate {

    var loginButton: FBSDKLoginButton?
    var data = [[NSObject:AnyObject]]()
    var downloadGroup = dispatch_group_create()
    
    var currentUser: User!
    var card: CardViewController!
    var userQueue = [User]()
    
    var mpcManager: MPCManager!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let loginButton = FBSDKLoginButton()
        
        loginButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.height * 0.95)
        loginButton.readPermissions = ["public_profile", "email", "user_events", "user_likes", "user_tagged_places", "user_hometown", "user_videos"]
        loginButton.delegate = self
        self.loginButton = loginButton
        self.view.addSubview(loginButton)
        label = UILabel(frame: CGRect(x: 20, y: self.view.frame.height * 0.95 - loginButton.frame.height/3, width: 20, height: 20))
        label.text = "0"
        self.view.addSubview(label)

    }
    


    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if let err = error {
            print(err)
            return
        }
        if result.isCancelled {
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            self.currentUser = User(userID: result.token.userID, token: result.token.tokenString)
            self.mpcManager = MPCManager(user: self.currentUser)
            self.mpcManager.delegate = self
            self.mpcManager.browser.startBrowsingForPeers()
            self.mpcManager.advertiser.startAdvertisingPeer()
            (UIApplication.sharedApplication().delegate as! AppDelegate).mpc = self.mpcManager

            /* CREATING USER CARD */
            dispatch_async(dispatch_get_main_queue(), {
                self.createOtherView()
            })
        }
        
    }
    
    func foundPeer(discoveryInfo: [String:String], displayName:String) {
        let id = discoveryInfo["1"]
        let token = discoveryInfo["2"]
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
            print("found device")
            let u = User(userID: id!, token: token!)
            self.userQueue.append(u)
            print("downloaded profile")
            dispatch_async(dispatch_get_main_queue()) {
                self.label.text = "\(self.userQueue.count)"
            }
            print("\(UIDevice().name) Loaded \(displayName)")
        }
    }
    
    func createOtherView() {
        card = CardViewController(user: currentUser)
        card.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(card.view)
        self.view.bringSubviewToFront(loginButton!)
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.card?.view.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            if let u = userQueue.popLast() {
                card.updateUser(u)
                label.text = "\(userQueue.count)"
            } else {
                card.updateUser(currentUser)
            }
        }
    }


}

