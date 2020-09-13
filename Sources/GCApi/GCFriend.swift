//
//  Friend.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 07/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit

enum FriendRequestFields : String, CaseIterable {
    case id = "id"
    case requestorUserCode = "requestorUserCode"
    case requestor = "requestor"
    case requestedUserCode = "requestedUserCode"
    case requested = "requested"
    case message = "message"
    case isOutgoing = "isOutgoing"
}

class GCFriend: NSObject {

}
