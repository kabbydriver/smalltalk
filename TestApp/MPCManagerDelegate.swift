//
//  MPCManagerDelegate.swift
//  TestApp
//
//  Created by Kabir Gogia on 9/24/15.
//  Copyright (c) 2015 Kabir. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol MPCManagerDelegate {

    func foundPeer(discorveryInfo: [String: String], displayName: String)

}