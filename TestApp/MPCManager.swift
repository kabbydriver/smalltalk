//
//  MPCManager.swift
//  TestApp
//
//  Created by Kabir Gogia on 9/17/15.
//  Copyright (c) 2015 Kabir. All rights reserved.
//

import MultipeerConnectivity

class MPCManager: NSObject, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
   
    var peer: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    var delegate: MPCManagerDelegate?
    var masterUser: User!
    var foundPeers = [String:String]()
    
    init(user: User) {
        super.init()
        
        self.masterUser = user
        
        peer = MCPeerID(displayName: UIDevice().name)
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "test-app")
        browser.delegate = self
        
        var dict = [String:String]()
        
        //discovery info must be less than 400 bytes, and K-V pair must be less than 255 bytes
        dict["1"] = masterUser.id
        dict["2"] = masterUser.tokenString
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: dict, serviceType: "test-app")
        advertiser.delegate = self
    }
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let id = info!["1"]
        let token = info!["2"]
        if foundPeers[id!] != nil {
            print("\(UIDevice().name) found duplicate \(peerID.displayName)")
            return;
        }
        foundPeers[id!] = token
        delegate?.foundPeer(info!, displayName: peerID.displayName)
        print("\(UIDevice().name) Found \(peerID.displayName)")
        
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost: \(peerID.displayName)")
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: ((Bool, MCSession) -> Void)) {
        print("Invited By: \(peerID.displayName)")
    }

}
