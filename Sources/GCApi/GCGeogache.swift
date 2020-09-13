//
//  Geogache.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 06/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit
import CoreLocation


enum GeocacheFields : String, CaseIterable {
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

enum LocationFields : String, CaseIterable {
    case countryId = "countryId"
    case country = "country"
    case stateId = "stateId"
    case state = "state"
}

class LocationModel:Codable {
    let countryId:Int?   //id of country
    let country:String?   //display name of country
    let stateId:Int?   //id of state
    let state:String?   //display name of state
}

enum SizeFields : String, CaseIterable {
    case id = "id"
    case name = "name"
}

enum GeocacheLimitFields : String, CaseIterable {
    case liteCallsRemaining = "liteCallsRemaining"
    case liteCallsSecondsToLive = "liteCallsSecondsToLive"
    case fullCallsRemaining = "fullCallsRemaining"
    case fullCallsSecondsToLive = "fullCallsSecondsToLive"
}

enum ImageFields : String, CaseIterable {
    case url = "url"
    case thumbnailUrl = "thumbnailUrl" // (string, optional, read only),
    case largeUrl = "largeUrl" // (string, optional, read only),
    case referenceCode = "referenceCode" // (string, optional),
    case createdDate = "createdDate" // (string, optional),
    case capturedDate = "capturedDate" // (string, optional),
    case description = "description" // (string, optional): Description of the image ,
    case guid = "guid" // (string, optional)
}

class ImageModel: Codable {
    let url:String? // (string, optional),
    let thumbnailUrl: String? // (string, optional, read only),
    let largeUrl: String? // (string, optional, read only),
    let referenceCode:String? // (string, optional),
    let createdDate:Date? // (string, optional),
    let capturedDate:Date? // (string, optional),
    let description:String? // (string, optional): Description of the image ,
    let guid:String? // (string, optional)
}
enum ImageToUploadFields : String, CaseIterable {
    case description = "description"
    case base64ImageData = "base64ImageData"
    case guid = "guid"
}

enum UserDataFields : String, CaseIterable {
    case note = "note"
    case isFavorited = "isFavorited"
    case foundDate = "foundDate"
    case dnfDate = "dnfDate"
    case correctedCoordinates = "correctedCoordinates"
}

enum CoordinatesFields : String, CaseIterable {
    case latitude = "latitude"
    case longitude = "longitude"
}

@objcMembers class CoordinatesModel: NSObject, Codable {
    init(lat: Decimal, long: Decimal) {
        latitude = lat
        longitude = long
    }
    var latitude: Decimal
    var longitude: Decimal
}

enum UserReferenceFields : String, CaseIterable {
    case referenceCode = "referenceCode"
    case username = "username"
    case avatarUrl = "avatarUrl"
}

enum TypeFields : String, CaseIterable {
    case id = "id"
    case name = "name"
    case imageUrl = "imageUrl"
}

enum GCGeocacheType :Int, CaseIterable, Codable{
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

    init(from decoder: Decoder) throws {
         let container = try decoder.singleValueContainer()
         let string = try container.decode(Int.self)
         self = GCGeocacheType(rawValue: string) ?? .Unknown
     }
}

class GeocacheTypeModel : Codable {
    let id: GCGeocacheType?
    let name: String?
    let imageUrl: URL?
}

enum Size : String, Codable {
    case notChosen = "Not Chosen"
    case micro = "Micro"
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    case virtual = "Virtual"
    case other = "Other"
}

enum Status : String, Codable{
    case unpublished = "Unpublished"
    case active = "Active"
    case disabled = "Disabled"
    case locked = "Locked"
    case archived = "Archived"
}

class GeocacheModel : Codable {
    let referenceCode : String?
    let name : String?
    let difficulty : Double?
    let terrain : Double?
    let favoritePoints : Int?
    let trackableCount : Int?
    let placedDate : Date?
    let publishedDate : Date?
    let geocacheType : GeocacheTypeModel?
    let geocacheSize : GeocacheSizeModel?
    let userData : UserDataModel?
    let status : Status?
    let location : LocationModel?
    let postedCoordinates : CoordinatesModel?
    let lastVisitedDate : Date?
    let ownerCode : String?
    let ownerAlias : String?
    let isPremiumOnly : Bool?
    let shortDescription : String?
    let longDescription : String?
    let hints : String?
    let attributes : [AttributeModel]?
    let ianaTimezoneId : String?
    let relatedWebPage : String?
    let url : String?
    let containsHtml : Bool?
    let owner : UserModel?
    let additionalWaypoints : [AdditionalWaypointModel]?
    let userWaypoints: [UserWaypointModel]?
    let trackables: [TrackableModel]?
    let geocacheLogs: [GeocaheLogModel]?
    let images:[ImageModel]?
}

class AdditionalWaypointModel: Codable {
    let name: String?        //display name of the waypoint
    let description:String?  //text about the waypoint
    let typeId: WaypointType?//type of the waypoint (see Waypoint Types for more info)
    let typeName: String?    //display name of the type
    let prefix: String?      //short category prefix of the waypoint type
    let url: URL?            //geocaching.com web page associated with the waypoint
    let coordinates: CoordinatesModel?   //latitude and longitude of the waypoint
}


class UserWaypointModel : Codable {
    init(coordinateDescription: String, coordinatesModel: CoordinatesModel, cacheCode: String) {
        description = coordinateDescription
        coordinates = coordinatesModel
        geocacheCode = cacheCode
    }
    var referenceCode: String?
    var description: String?
    var isCorrectedCoordinates: Bool?
    var coordinates: CoordinatesModel?
    var geocacheCode: String?
}

class AttributeModel: Codable {
    let id: Int?         //identifier of the attribute
    let name: String?    //display name of the attribute
    let isOn: Bool?      //flag for if the attribute is a positive or negative (e.g. available 24/7 vs not available 24/7)
    let imageUrl:String?    //link to the image for the attribute
}

class CacheSizeModel:Codable {
    let id:Int?    //id of size
    let name:String? //display name of size
}

enum WaypointType: Int, Codable {
    case ParkingArea = 217
    case VirtualStage = 218
    case PhysicalStage = 219
    case FinalLocation = 220
    case Trailhead = 221
    case ReferencePoint = 452
}

enum CacheSize:Int, Codable, CaseIterable {
    case Unknown = 1
    case Micro = 2
    case Small = 8
    case Regular = 3
    case Large = 4
    case Virtual = 5
    case Other = 6
}

class GeocacheSizeModel: Codable {
    let id : CacheSize?
    let name: String?
}

class UserDataModel: Codable {
    let note: String?     //personal geocache note only visible to user
    let isFavorited:Bool? //if the user has awarded this geocache a favorite point
    let foundDate:Date?  //the date the user found the geocache in the timezone of the geocache (null if not found)
    let dnfDate:Date?    //the date the user logged a DNF on the geocache in the timezone of the geocache (null if no DNF exists)
    let correctedCoordinates:CoordinatesModel? //latitude and longitude of the user's solved coordinates
}

class GeocacheNoteModel: NSObject, Codable {
    init(note:String) {
        self.note = note
        super.init()
    }

    let note : String?
}

class GCGeogache: NSObject {

    static func getCache(cacheCode : String, fields : Array<GeocacheFields>, logs:Int = 0, trackables: Int = 0, completionHandler: @escaping (Result<GeocacheModel, GCError>) -> Void) {
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

    static func getCaches(cacheCodes : Array<String>, fields : Array<GeocacheFields>, logs:Int = 0, trackables: Int = 0, isLite:Bool = false, completionHandler: @escaping (Result<Array<GeocacheModel>, GCError>) -> Void) {
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

    static func searchCaches(centerPoint:CLLocationCoordinate2D, radiusMiles:Int, fields : Array<GeocacheFields> = GeocacheFields.allCases, logs:Int = 0, trackables: Int = 0, skip:Int = 0, take:Int = 0, isLite:Bool = false, cacheTypes: Array<GCGeocacheType> = GCGeocacheType.allCases, completionHandler: @escaping (Result<Array<GeocacheModel>, GCError>) -> Void) {
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

    static func searchCaches(upperLeft:CLLocationCoordinate2D, lowerRight:CLLocationCoordinate2D, fields : Array<GeocacheFields>, logs:Int = 0, trackables: Int = 0, skip:Int = 0, take:Int = 50, isLite:Bool = false, cacheTypes: Array<GCGeocacheType>? = GCGeocacheType.allCases, terrainFrom:Int? = nil, terrainTo:Int? = nil, diffFrom:Int? = nil, diffTo:Int? = nil, cacheSizes: Array<CacheSize>? = CacheSize.allCases, minFavouritePoints:Int? = nil, excludeFoundBy:String? = nil, completionHandler: @escaping (Result<Array<GeocacheModel>, GCError>) -> Void) {
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

    static func verifyFinalCoordinates(cacheCode : String, coordinates:CoordinatesModel, completionHandler: @escaping (Result<Bool, GCError>) -> Void) {
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

    static func updateFinalCoordinates(cacheCode : String, coordinates:CoordinatesModel, completionHandler: @escaping (Result<UserWaypointModel, GCError>) -> Void) {
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

    static func addCoordinates(userWaypoint:UserWaypointModel, completionHandler: @escaping (Result<UserWaypointModel, GCError>) -> Void) {
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

    static func updateCoordinates(modelId : String, userWaypoint:UserWaypointModel, completionHandler: @escaping (Result<UserWaypointModel, GCError>) -> Void) {
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

    static func getCoordinates(cacheId : String, completionHandler: @escaping (Result<[UserWaypointModel], GCError>) -> Void) {
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

    static func deleteCoordinates(modelId : String, completionHandler: @escaping (Result<Bool, GCError>) -> Void) {
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
    
    static func putNote(cacheCode : String, note:String, completionHandler: @escaping (Result<GeocacheNoteModel, GCError>) -> Void) {
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

    static func getGeocacheTypes(completionHandler: @escaping (Result<Array<GeocacheTypeModel>, GCError>) -> Void) {
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

    static func getAttributeTypes(completionHandler: @escaping (Result<Array<AttributeTypeModel>, GCError>) -> Void) {
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


