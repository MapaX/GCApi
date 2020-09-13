//
//  Logs.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 06/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit

public enum LogFieds : String, CaseIterable {
    case referenceCode = "referenceCode"
    case ownerCode = "ownerCode"
    case imageCount = "imageCount"
    case loggedDate = "loggedDate"
    case text = "text"
    case geocacheLogType = "geocacheLogType"
    case updatedCoordinates = "updatedCoordinates"
    case geocacheCode = "geocacheCode"
    case geocacheName = "geocacheName"
    case ianaTimezoneId = "ianaTimezoneId"
    case usedFavoritePoint = "usedFavoritePoint"
    case isEncoded = "isEncoded"
    case isArchived = "isArchived"
    case url = "url"
    case owner = "owner"
}

public enum GeocacheLogType: Int, Codable {
    case FoundIt = 2          // found the geocache
    case DidntfindIt = 3          // Did not find (DNF) the geocache
    case Writenote = 4          // Adding a comment to the geocache
    case Archive = 5          // changing the status of the geocache to archived
    case PermanentlyArchived = 6          // changing the status of the geocache to archived (deprecated)
    case NeedsArchived = 7          // flagging the geocache as needing to be archived
    case WillAttend = 9          // RSVPing for an event
    case Attended = 10          // Attended an event (counts as a find)
    case WebcamPhotoTaken = 11          // Successfully captured a webcam geocache (counts as a find)
    case Unarchive = 12          // changing the status of the geocache from archived to active (reviewer only)
    case TemporarilyDisableListing = 22          // changing the status of the geocache to disabled
    case EnableListing = 23          // changing the status of the geocache from disabled to active (reviewer only)
    case PublishListing = 24          // changing the status of the geocache from unpublished to active (reviewer only)
    case RetractListing = 25          // retracting the geocache (admin only)
    case NeedsMaintenance = 45          // flagging a geocache owner that the geocache needs some attention
    case OwnerMaintenance = 46          // announcing that owner maintenance was done
    case UpdateCoordinates = 47          // updating the coordinates of the geocache
    case PostReviewerNote = 68          // a note left by the reviewer (reviewer only)
    case PostReviewerNote2 = 18          // a note left by the reviewer (reviewer only)
    case Announcement = 74          // event host announcement to attendees
    case Unknown = 999

    public init(from decoder: Decoder) throws {
         let container = try decoder.singleValueContainer()
         let string = try container.decode(Int.self)
         self = GeocacheLogType(rawValue: string) ?? .Unknown
     }
}

public class GeocacheLogTypeModel: NSObject, Codable {
    public init(logType:GeocacheLogType) {
        self.id = logType
        super.init()
    }
    public var id:GeocacheLogType  //identifier of the type
    public var name:String? = nil  //the name of the type
    public var imageUrl:String? = nil //link to the image of the type
}

public class GeocaheLogModel: NSObject, Codable {
    public init(loggedDate:Date, text:String, logType:GeocacheLogType, coordinates:CoordinatesModel? = nil, geocacheCode:String) {
        self.loggedDate = loggedDate
        self.text = text
        self.geocacheLogType = GeocacheLogTypeModel(logType: logType)
        self.updatedCoordinates = coordinates
        self.geocacheCode = geocacheCode
        super.init()
    }
    public var referenceCode:String? = nil   //uniquely identifies the geocache log    No    No
    public var ownerCode:String? = nil   //identifier of the log owner    No    No
    public var imageCount:Int? = nil    //number of images associated with geocache log    No    No
    public var loggedDate:Date?    //date and time of when user logged the geocache in the timezone of the geocache    Yes    Yes
    public var text:String? = nil   //display text of the geocache log    Yes    Yes
    public var geocacheLogType:GeocacheLogTypeModel? = nil   //type of the geocache log (see Geocache Log Types for more info)    Yes (only id field is required)    Yes (only id field is required)
    public var updatedCoordinates:CoordinatesModel? = nil   //latitude and longitude of the geocache (only used with log type 47 - Update Coordinates)    Optional    Yes
    public var geocacheCode:String? = nil   //identifier of the associated geocache    Yes    No
    public var geocacheName:String? = nil   //name of the associated geocache    No    No
    public var ianaTimezoneId:String? = nil   //timezone of the associated geocache    No    No
    public var usedFavoritePoint:Bool? = nil   //if a favorite point was awarded from this log    Optional, defaults to false    No
    public var isEncoded:Bool? = nil   //if log was encrypted using ROT13. This field is grandfathered to logs already set to true. New logs cannot be encoded.    No    No
    public var isArchived:Bool? = nil   //if the log has been deleted    No    No
    public var url:String? = nil   //geocaching.com web page associated with geocache log    No    No
    public var owner:UserModel? = nil   //information about the owner of the geocache log    No    No
}

public class LogDraftModel: NSObject, Codable {
    public init(cacheCode:String) {
        geocacheCode = cacheCode
        super.init()
    }

    public var referenceCode: String? = nil //uniquely identifies the log draft    No    No
    public var geocacheCode: String? = nil  //    string    identifer of the geocache    Yes    No
    public var geocacheName: String? = nil  //  string    name of the geocache    No    No
    public var geocacheLogType: GeocacheLogTypeModel? = nil //    Type    type of the geocache log (see Geocache Log Types for more info)    Yes (only the id field is required)    No
    public var note: String? = nil   //    string    display text of the log draft    Optional    Yes
    public var loggedDate: Date? = nil   //    datetime    when the user logged the geocache in the geocache's local timezone    Optional, defaults to current datetime    No
    public var imageCount: Int?  = nil //    integer    number of images associated with draft    No    No
    public var useFavoritePoint: Bool? = nil  //    boolean    whether to award favorite point when    Optional, defaults to false    Yes
}

public class GCLogs: NSObject {

    public static func createGeocacheLog(geocachelog:GeocaheLogModel, fields : Array<LogFieds>, completionHandler: @escaping (Result<GeocaheLogModel, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocachelogs")
        query.add(fields: fields)
        GCApi.shared().getData(url: query, parseClass: GeocaheLogModel.self, httpMethod: .post, payload: geocachelog) { (result) in
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

    public static func getCacheLogs(cacheCode : String, fields : Array<LogFieds>, skip:Int = 0, take:Int = 50, completionHandler: @escaping (Result<Array<GeocaheLogModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocaches/\(cacheCode)/geocachelogs/")
        query.add(skip: skip, take: take)
        query.add(fields: fields)
        GCApi.shared().getData(url: query, parseClass: Array<GeocaheLogModel>.self, payload: "") { (result) in
            switch result {
            case .failure(let error):
                //print(error)
                completionHandler(.failure(error))
            case .success(let model):
                //print(model)
                completionHandler(.success(model))
            }
        }
    }

    public static func createLogDraft(logDraft:LogDraftModel, fields : Array<LogFieds>, completionHandler: @escaping (Result<LogDraftModel, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "logdrafts")
        query.add(fields: fields)
        GCApi.shared().getData(url: query, parseClass: LogDraftModel.self, httpMethod: .post, payload: logDraft) { (result) in
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

    public static func getLogDrafts(fields : Array<LogFieds>, completionHandler: @escaping (Result<Array<LogDraftModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "logdrafts")
        query.add(fields: fields)
        GCApi.shared().getData(url: query, parseClass: Array<LogDraftModel>.self, payload: "") { (result) in
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

    public static func getGeocacheLogTypes(completionHandler: @escaping (Result<Array<GeocacheLogTypeModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocachelogtypes")
        GCApi.shared().getData(url: query, parseClass: Array<GeocacheLogTypeModel>.self, payload: "") { (result) in
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
