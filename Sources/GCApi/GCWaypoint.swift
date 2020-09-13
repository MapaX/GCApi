//
//  Waypoint.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 07/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit

enum UserWaypointFields : String, CaseIterable {
    case referenceCode = "referenceCode"
    case description = "description"
    case isCorrectedCoordinates = "isCorrectedCoordinates"
    case coordinates = "coordinates"
    case geocacheCode = "geocacheCode"
}

enum AdditionalWaypointFields : String, CaseIterable {
    case name = "name"
    case description = "description"
    case typeId = "typeId"
    case typeName = "typeName"
    case prefix = "prefix"
    case coordinates = "coordinates"
}

enum AttributeFields : String, CaseIterable {
    case id = "id"
    case name = "name"
    case isOn = "isOn"
    case imageUrl = "imageUrl"
}

enum AttributeTypeFields : String, CaseIterable {
    case id = "id"
    case name = "name"
    case hasYesOption = "hasYesOption"
    case hasNoOption = "hasNoOption"
    case yesIconUrl = "yesIconUrl"
}

class AttributeTypeModel: Codable {
    var id: Int?             //    integer    identifier of the attribute
    var name: String?        //    string    display name of the attribute
    var hasYesOption: Bool?  //   boolean    flag for if the attribute can be set to isOn = true
    var hasNoOption: Bool? //   boolean    flag for if the attribute can be set to isOn = false
    var yesIconUrl: String? //   string    image url for the attribute if isOn = true
    var noIconUrl: String? //   string    image url for the attribute if isOn = false
    var notChosenIconUrl: String? //    string    image url for the attribute if not chosen
}

class GCWaypoint: NSObject {

}
