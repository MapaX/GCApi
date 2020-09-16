//
//  Geogache.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 06/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit
import CoreLocation


public enum GeocacheFields : String, CaseIterable {
    case referenceCode = "referenceCode"
    case name = "name"
    case difficulty = "difficulty"
    case terrain = "terrain"
    case favoritePoints = "favoritePoints"
    case trackableCount = "trackableCount"
    case placedDate = "placedDate"
    case publishedDate = "publishedDate"
    case geocacheType = "geocacheType"
    case geocacheSize = "geocacheSize"
    case userData = "userData"
    case status = "status"
    case location = "location"
    case postedCoordinates = "postedCoordinates"
    case lastVisitedDate = "lastVisitedDate"
    case ownerCode = "ownerCode"
    case ownerAlias = "ownerAlias"
    case isPremiumOnly = "isPremiumOnly"
    case shortDescription = "shortDescription"
    case longDescription = "longDescription"
    case hints = "hints"
    case attributes = "attributes"
    case ianaTimezoneId = "ianaTimezoneId"
    case relatedWebPage = "relatedWebPage"
    case url = "url"
    case containsHtml = "containsHtml"
    case owner = "owner"
    case additionalWaypoints = "additionalWaypoints"
    case userWaypoints = "userWaypoints"
}

public enum LocationFields : String, CaseIterable {
    case countryId = "countryId"
    case country = "country"
    case stateId = "stateId"
    case state = "state"
}

public class LocationModel:Codable {
    public let countryId:Int?   //id of country
    public let country:String?   //display name of country
    public let stateId:Int?   //id of state
    public let state:String?   //display name of state
}

public enum SizeFields : String, CaseIterable {
    case id = "id"
    case name = "name"
}

public enum GeocacheLimitFields : String, CaseIterable {
    case liteCallsRemaining = "liteCallsRemaining"
    case liteCallsSecondsToLive = "liteCallsSecondsToLive"
    case fullCallsRemaining = "fullCallsRemaining"
    case fullCallsSecondsToLive = "fullCallsSecondsToLive"
}

public enum ImageFields : String, CaseIterable {
    case url = "url"
    case thumbnailUrl = "thumbnailUrl" // (string, optional, read only),
    case largeUrl = "largeUrl" // (string, optional, read only),
    case referenceCode = "referenceCode" // (string, optional),
    case createdDate = "createdDate" // (string, optional),
    case capturedDate = "capturedDate" // (string, optional),
    case description = "description" // (string, optional): Description of the image ,
    case guid = "guid" // (string, optional)
}

public class ImageModel: Codable {
    public let url:String? // (string, optional),
    public let thumbnailUrl: String? // (string, optional, read only),
    public let largeUrl: String? // (string, optional, read only),
    public let referenceCode:String? // (string, optional),
    public let createdDate:Date? // (string, optional),
    public let capturedDate:Date? // (string, optional),
    public let description:String? // (string, optional): Description of the image ,
    public let guid:String? // (string, optional)
}
public enum ImageToUploadFields : String, CaseIterable {
    case description = "description"
    case base64ImageData = "base64ImageData"
    case guid = "guid"
}

public enum UserDataFields : String, CaseIterable {
    case note = "note"
    case isFavorited = "isFavorited"
    case foundDate = "foundDate"
    case dnfDate = "dnfDate"
    case correctedCoordinates = "correctedCoordinates"
}

public enum CoordinatesFields : String, CaseIterable {
    case latitude = "latitude"
    case longitude = "longitude"
}

@objcMembers public class CoordinatesModel: NSObject, Codable {
    public init(lat: Decimal, long: Decimal) {
        latitude = lat
        longitude = long
    }
    public var latitude: Decimal
    public var longitude: Decimal
}

public enum UserReferenceFields : String, CaseIterable {
    case referenceCode = "referenceCode"
    case username = "username"
    case avatarUrl = "avatarUrl"
}

public enum TypeFields : String, CaseIterable {
    case id = "id"
    case name = "name"
    case imageUrl = "imageUrl"
}

public enum GCGeocacheType :Int, CaseIterable, Codable{
    case traditional = 2
    case multicache = 3
    case virtual = 4
    case letterboxhybrid = 5
    case event = 6
    case mysteryUnknown = 8
    case projectAPE = 9
    case webcam = 11
    case locationlessCache = 12
    case cacheInTrashOutEvent = 13
    case earthcache = 137
    case megaEvent = 453
    case gPSAdventuresExhibit = 1304
    case wherigo = 1858
    case communityCelebrationEvent = 3653
    case geocachingHQ = 3773
    case geocachingHQCelebration = 3774
    case geocachingHQBlockParty = 4738
    case gigaEvent = 7005
    case Unknown = 99999

    public init(from decoder: Decoder) throws {
         let container = try decoder.singleValueContainer()
         let string = try container.decode(Int.self)
         self = GCGeocacheType(rawValue: string) ?? .Unknown
     }
}

public class GeocacheTypeModel : Codable {
    public let id: GCGeocacheType?
    public let name: String?
    public let imageUrl: URL?
}

public enum Size : String, Codable {
    case notChosen = "Not Chosen"
    case micro = "Micro"
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    case virtual = "Virtual"
    case other = "Other"
}

public enum Status : String, Codable{
    case unpublished = "Unpublished"
    case active = "Active"
    case disabled = "Disabled"
    case locked = "Locked"
    case archived = "Archived"
}

public class GeocacheModel : Codable {
    public let referenceCode : String?
    public let name : String?
    public let difficulty : Double?
    public let terrain : Double?
    public let favoritePoints : Int?
    public let trackableCount : Int?
    public let placedDate : Date?
    public let publishedDate : Date?
    public let geocacheType : GeocacheTypeModel?
    public let geocacheSize : GeocacheSizeModel?
    public let userData : UserDataModel?
    public let status : Status?
    public let location : LocationModel?
    public let postedCoordinates : CoordinatesModel?
    public let lastVisitedDate : Date?
    public let ownerCode : String?
    public let ownerAlias : String?
    public let isPremiumOnly : Bool?
    public let shortDescription : String?
    public let longDescription : String?
    public let hints : String?
    public let attributes : [AttributeModel]?
    public let ianaTimezoneId : String?
    public let relatedWebPage : String?
    public let url : String?
    public let containsHtml : Bool?
    public let owner : UserModel?
    public let additionalWaypoints : [AdditionalWaypointModel]?
    public let userWaypoints: [UserWaypointModel]?
    public let trackables: [TrackableModel]?
    public let geocacheLogs: [GeocaheLogModel]?
    public let images:[ImageModel]?
}

public class AdditionalWaypointModel: Codable {
    public let name: String?        //display name of the waypoint
    public let description:String?  //text about the waypoint
    public let typeId: WaypointType?//type of the waypoint (see Waypoint Types for more info)
    public let typeName: String?    //display name of the type
    public let prefix: String?      //short category prefix of the waypoint type
    public let url: URL?            //geocaching.com web page associated with the waypoint
    public let coordinates: CoordinatesModel?   //latitude and longitude of the waypoint
}


public class UserWaypointModel : Codable {
    public init(coordinateDescription: String, coordinatesModel: CoordinatesModel, cacheCode: String) {
        description = coordinateDescription
        coordinates = coordinatesModel
        geocacheCode = cacheCode
    }
    public var referenceCode: String?
    public var description: String?
    public var isCorrectedCoordinates: Bool?
    public var coordinates: CoordinatesModel?
    public var geocacheCode: String?
}

public class AttributeModel: Codable {
    public let id: Int?         //identifier of the attribute
    public let name: String?    //display name of the attribute
    public let isOn: Bool?      //flag for if the attribute is a positive or negative (e.g. available 24/7 vs not available 24/7)
    public let imageUrl:String?    //link to the image for the attribute
}

public class CacheSizeModel:Codable {
    public let id:Int?    //id of size
    public let name:String? //display name of size
}

public enum WaypointType: Int, Codable {
    case ParkingArea = 217
    case VirtualStage = 218
    case PhysicalStage = 219
    case FinalLocation = 220
    case Trailhead = 221
    case ReferencePoint = 452
}

public enum CacheSize:Int, Codable, CaseIterable {
    case Unknown = 1
    case Micro = 2
    case Small = 8
    case Regular = 3
    case Large = 4
    case Virtual = 5
    case Other = 6
}

public class GeocacheSizeModel: Codable {
    public let id : CacheSize?
    public let name: String?
}

public class UserDataModel: Codable {
    public let note: String?     //personal geocache note only visible to user
    public let isFavorited:Bool? //if the user has awarded this geocache a favorite point
    public let foundDate:Date?  //the date the user found the geocache in the timezone of the geocache (null if not found)
    public let dnfDate:Date?    //the date the user logged a DNF on the geocache in the timezone of the geocache (null if no DNF exists)
    public let correctedCoordinates:CoordinatesModel? //latitude and longitude of the user's solved coordinates
}

public class GeocacheNoteModel: NSObject, Codable {
    init(note:String) {
        self.note = note
        super.init()
    }

    public let note : String?
}

public class GCGeogache: NSObject {

    public static func getCache(cacheCode : String, fields : Array<GeocacheFields>, logs:Int = 0, trackables: Int = 0, userwaypoints: Int = 0, completionHandler: @escaping (Result<GeocacheModel, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocaches/\(cacheCode)")
        query.addIsLite(isLite: false)
        query.add(fields: fields)
        query.add(logs: logs, trackables: trackables)
        GCApi.shared().getData(url: query, parseClass: GeocacheModel.self, payload: "") { (result) in
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

    public static func getCaches(cacheCodes : Array<String>, fields : Array<GeocacheFields>, logs:Int = 0, trackables: Int = 0, userwaypoints: Int = 0, isLite:Bool = false, completionHandler: @escaping (Result<Array<GeocacheModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocaches")
        query.addRefCodes(refCodes: cacheCodes)
        query.addIsLite(isLite: isLite)
        query.add(fields: fields)
        query.add(logs: logs, trackables: trackables)
        GCApi.shared().getData(url: query, parseClass: Array<GeocacheModel>.self, payload: "") { (result) in
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

    public static func searchCaches(centerPoint:CLLocationCoordinate2D, radiusMiles:Int, fields : Array<GeocacheFields> = GeocacheFields.allCases, logs:Int = 0, trackables: Int = 0, skip:Int = 0, userwaypoints: Int = 0, take:Int = 0, isLite:Bool = false, cacheTypes: Array<GCGeocacheType> = GCGeocacheType.allCases, completionHandler: @escaping (Result<Array<GeocacheModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocaches/search/")
        query.add(centerPoint: centerPoint, radiusMiles: radiusMiles)
        query.addIsLite(isLite: isLite)
        query.add(fields: fields)
        query.add(skip: skip, take: take)
        query.addType(fields: cacheTypes)
        query.add(logs: logs, trackables: trackables)
        GCApi.shared().getData(url: query, parseClass: Array<GeocacheModel>.self, payload: "") { (result) in
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

    public static func searchCaches(upperLeft:CLLocationCoordinate2D, lowerRight:CLLocationCoordinate2D, fields : Array<GeocacheFields>, logs:Int = 0, trackables: Int = 0, userwaypoints: Int = 0, skip:Int = 0, take:Int = 50, isLite:Bool = false, cacheTypes: Array<GCGeocacheType>? = GCGeocacheType.allCases, terrainFrom:Int? = nil, terrainTo:Int? = nil, diffFrom:Int? = nil, diffTo:Int? = nil, cacheSizes: Array<CacheSize>? = CacheSize.allCases, minFavouritePoints:Int? = nil, excludeFoundBy:String? = nil, completionHandler: @escaping (Result<Array<GeocacheModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocaches/search/")
        query.add(upperLeft: upperLeft, lowerRight: lowerRight)
        query.addIsLite(isLite: isLite)
        if cacheTypes != nil {
            query.addType(fields: cacheTypes ?? GCGeocacheType.allCases)
        }
        if let username = excludeFoundBy {
            query.addExludeFound(userId: username)
        }
        if let tFrom = terrainFrom, let tTo = terrainTo {
            query.add(terrain: tFrom, to: tTo)
        }
        if let dFrom = diffFrom, let dTo = diffTo {
            query.add(difficulty: dFrom, to: dTo)
        }
        if let cSizes = cacheSizes {
            query.add(sizes: cSizes)
        }

        if let favPoints = minFavouritePoints, favPoints > 0 {
            query.add(favourite: favPoints)
        }
        query.add(fields: fields)
        query.add(logs: logs, trackables: trackables)
        query.add(skip: skip, take: take)


        GCApi.shared().getData(url: query, parseClass: Array<GeocacheModel>.self, payload: "") { (result) in
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

    public static func verifyFinalCoordinates(cacheCode : String, coordinates:CoordinatesModel, completionHandler: @escaping (Result<Bool, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocaches/\(cacheCode)/finalcoordinates")

        GCApi.shared().getData(url: query, parseClass: Bool.self, httpMethod: .post, payload: coordinates) { (result) in
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

    public static func updateFinalCoordinates(cacheCode : String, coordinates:CoordinatesModel, completionHandler: @escaping (Result<UserWaypointModel, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocaches/\(cacheCode)/correctedcoordinates")
        query.add(fields: UserWaypointFields.allCases)
        GCApi.shared().getData(url: query, parseClass: UserWaypointModel.self, httpMethod: .put, payload: coordinates) { (result) in
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

    public static func addCoordinates(userWaypoint:UserWaypointModel, completionHandler: @escaping (Result<UserWaypointModel, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "userwaypoints")
        query.add(fields: UserWaypointFields.allCases)
        GCApi.shared().getData(url: query, parseClass: UserWaypointModel.self, httpMethod: .post, payload: userWaypoint) { (result) in
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

    public static func updateCoordinates(modelId : String, userWaypoint:UserWaypointModel, completionHandler: @escaping (Result<UserWaypointModel, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "userwaypoints/\(modelId)")
        query.add(fields: UserWaypointFields.allCases)
        GCApi.shared().getData(url: query, parseClass: UserWaypointModel.self, httpMethod: .put, payload: userWaypoint) { (result) in
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

    public static func getCoordinates(cacheId : String, completionHandler: @escaping (Result<[UserWaypointModel], GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocaches/\(cacheId)/userwaypoints")
        query.add(fields: UserWaypointFields.allCases)
        GCApi.shared().getData(url: query, parseClass: Array<UserWaypointModel>.self, httpMethod: .get, payload: "") { (result) in
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

    public static func deleteCoordinates(modelId : String, completionHandler: @escaping (Result<Bool, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "userwaypoints/\(modelId)")
        GCApi.shared().getData(url: query, parseClass: Bool.self, httpMethod: .delete, payload: "") { (result) in
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
    
    public static func putNote(cacheCode : String, note:String, completionHandler: @escaping (Result<GeocacheNoteModel, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocaches/\(cacheCode)/notes")
        let noteModel = GeocacheNoteModel(note: note)
        GCApi.shared().getData(url: query, parseClass: GeocacheNoteModel.self, httpMethod: .put, payload: noteModel) { (result) in
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

    public static func getGeocacheTypes(completionHandler: @escaping (Result<Array<GeocacheTypeModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocachetypes")
        GCApi.shared().getData(url: query, parseClass: Array<GeocacheTypeModel>.self, payload: "") { (result) in
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

    public static func getAttributeTypes(completionHandler: @escaping (Result<Array<AttributeTypeModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "attributes")
        GCApi.shared().getData(url: query, parseClass: Array<AttributeTypeModel>.self, payload: "") { (result) in
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


