//
//  TrackableLog.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 07/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit

enum TrackableLogFields : String, CaseIterable {
    case referenceCode = "referenceCode"
    case ownerCode = "ownerCode"
    case trackableCode = "trackableCode"
    case geocacheCode = "geocacheCode"
    case geocacheName = "geocacheName"
    case loggedDate = "loggedDate"
    case text = "text"
    case imageCount = "imageCount"
    case isRot13Encoded = "isRot13Encoded"
    case trackableLogType = "trackableLogType"
    case coordinates = "coordinates"
    //case trackingNumber = "trackingNumber" This cannot be requested
    case url = "url"
    case owner = "owner"
}

enum LogDraftFields : String, CaseIterable {
    case referenceCode = "referenceCode"
    case geocacheCode = "geocacheCode"
    case geocacheLogType = "geocacheLogType"
    case note = "note"
    case loggedDateUtc = "loggedDateUtc"
    case imageCount = "imageCount"
    case useFavoritePoint = "useFavoritePoint"
}

enum TrackableLogTypes: Int, Codable {
    case WriteNote = 4
    case RetrieveItFromACache = 13
    case DroppedOff = 14
    case Transfer = 15
    case MarkMissing = 16
    case GrabIt = 19
    case DiscoveredIt = 48
    case MoveToCollection = 69
    case MoveToInventory = 70
    case Visited = 75    
}

class TrackableLogTypeModel: NSObject, Codable {
    init(logType:TrackableLogTypes) {
        self.id = logType
        super.init()
    }
    var id:TrackableLogTypes  //identifier of the type
    var name:String? = nil  //the name of the type
    var imageUrl:String? = nil //link to the image of the type
}

class TrackableLogModel: NSObject, Codable {
    init(cacheCode:String?, cacheLoggedDate:Date, text:String, logType:TrackableLogTypes, trackingNumber:String) {
        self.geocacheCode = cacheCode
        self.loggedDate = cacheLoggedDate
        self.text = text
        self.trackableLogType = TrackableLogTypeModel(logType: logType)
        self.trackingNumber = trackingNumber
        super.init()
    }

    var referenceCode:String? = nil  //    string    uniquely identifies the trackable log    No    No
    var ownerCode:String? = nil  //    string    reference code of the owner    No    No
    var trackableCode:String? = nil  //    string    identifier of the related trackable    No (if not passed in, trackingNumber is required)    No
    var geocacheCode:String? = nil  //    string    identifier of the related geocache    Optional    No
    var geocacheName:String? = nil  //    string    name of the related geocache if there is one    Optional    No
    var loggedDate:Date? = nil  //    date    when the user logged the trackable    Yes    Yes
    var text:String? = nil  //    string    display text of the log    Yes    Yes
    var imageCount:Int? = nil   //   int    how many images are associated with the log    No    No
    var isRot13Encoded:Bool? = nil  //   bool    flag for if the text is ROT13 encoded    Optional, defaults to false    Yes
    var trackableLogType:TrackableLogTypeModel? = nil  //    Type    type of the trackable log (see Trackable Log Types for more info)    Yes (only id field is required)    No
    var coordinates:CoordinatesModel? = nil  //    Coordinates    latitude and longitude of the trackable log    Optional    No
    var trackingNumber:String? = nil  //    string    code only found on the trackable itself (only needed for creating a log, this will not be returned with any GET methods)    Required for retrieving from geocache, grab it, and discovered it activity types    No
    var url:String? = nil  //    string    geocaching.com web page associated with trackable log    No    No
    var owner :UserModel? = nil  //   User    information about the owner of the trackable log    No    No
}

class GCTrackableLog: NSObject {

    static func createTrackableLog(trackableLog: TrackableLogModel, fields : Array<TrackableLogFields>, completionHandler: @escaping (Result<TrackableLogModel, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "trackablelogs")
        query.add(fields: fields)
        GCApi.shared().getData(url: query, parseClass: TrackableLogModel.self, httpMethod: .post, payload: trackableLog) { (result) in
            switch result {
            case .failure(let error):
                print(error)
                completionHandler(.failure(error))
            case .success(let model):
                print(model)
                completionHandler(.success(model))
            }
        }
    }
    
}
