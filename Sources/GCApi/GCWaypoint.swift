//
//  Waypoint.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 07/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit

public enum UserWaypointFields : String, CaseIterable {
    case referenceCode = "referenceCode"
    case description = "description"
    case isCorrectedCoordinates = "isCorrectedCoordinates"
    case coordinates = "coordinates"
    case geocacheCode = "geocacheCode"
}

public enum AdditionalWaypointFields : String, CaseIterable {
    case name = "name"
    case description = "description"
    case typeId = "typeId"
    case typeName = "typeName"
    case prefix = "prefix"
    case coordinates = "coordinates"
}

public enum AttributeFields : String, CaseIterable {
    case id = "id"
    case name = "name"
    case isOn = "isOn"
    case imageUrl = "imageUrl"
}

public enum AttributeTypeFields : String, CaseIterable {
    case id = "id"
    case name = "name"
    case hasYesOption = "hasYesOption"
    case hasNoOption = "hasNoOption"
    case yesIconUrl = "yesIconUrl"
}

public class AttributeTypeModel: Codable {
    public var id: Int?             //    integer    identifier of the attribute
    public var name: String?        //    string    display name of the attribute
    public var hasYesOption: Bool?  //   boolean    flag for if the attribute can be set to isOn = true
    public var hasNoOption: Bool? //   boolean    flag for if the attribute can be set to isOn = false
    public var yesIconUrl: String? //   string    image url for the attribute if isOn = true
    public var noIconUrl: String? //   string    image url for the attribute if isOn = false
    public var notChosenIconUrl: String? //    string    image url for the attribute if not chosen
}

public class GCWaypoint: NSObject {

}
