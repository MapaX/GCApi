//
//  Trackable.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 07/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit
enum TrackableFieds : String, CaseIterable {
    case referenceCode = "referenceCode"
    case iconUrl = "iconUrl"
    case name = "name"
    case imageCount = "imageCount"
    case goal = "goal"
    case description = "description"
    case releasedDate = "releasedDate"
    case originCountry = "originCountry"
    case ownerCode = "ownerCode"
    case holderCode = "holderCode"
    case inHolderCollection = "inHolderCollection"
    case currentGeocacheCode = "currentGeocacheCode"
    case currentGeocacheName = "currentGeocacheName"
    case isMissing = "isMissing"
    case trackingNumber = "trackingNumber"
    case kilometersTraveled = "kilometersTraveled"
    case milesTraveled = "milesTraveled"
    case trackableType = "trackableType"
    case url = "url"
    case owner = "owner"
    case holder = "holder"
}

enum TrackableGetType: Int, Codable {
    case usersInventory = 1
    case usersCollection = 2
    case usersOwned = 3
}

class TrackableType: Codable {
    let id: Int?
    let name: String?
    let imageUrl: URL?
}

class TrackableModel: Codable {
    let referenceCode: String? //    string    uniquely identifies the trackable
    let iconUrl: String? //    string    link to image for trackable icon
    let name: String? //    string    display name of the trackable
    let imageCount: Int? //    int    how many owner images on the trackable
    let goal: String? //    string    the owner's goal for the trackable
    let description: String? //    string    text about the trackable
    let releasedDate: Date? //    date    when the trackable was activated
    let originCountry: String? //    string    where the trackable originated from
    let ownerCode: String? //    string    identifier about the owner
    let holderCode: String? //    string    user identifier about the current holder (null if not currently in someone's inventory)
    let inHolderCollection: Bool? //    bool    if the trackable is in the holder's collection
    let currentGeocacheCode: String? //    string    identifier of the geocache if the trackable is currently in one
    let currentGeocacheName: String? //    string    name of the geocache if the trackable is currently in one
    let isMissing: Bool? //    bool    flag is trackable is marked as missing
    let trackingNumber: String? //    string    unique number used to prove discovery of trackable. only returned if user matches the holderCode
    let kilometersTraveled: Decimal? //    Double    distance the trackable has traveled in kilometers
    let milesTraveled: Decimal? //    Double    distance the trackable has traveled in miles
    let trackableType: TrackableType? //    Type    type of the trackable
    let url: String? //    string    geocaching.com web page associated with trackable
    let owner: UserModel? //    information about the owner of the trackable
    let holder: UserModel? //    information about the holder of the trackable
}

class GCTrackable: NSObject {
    
    static func getCacheTrackables(cacheCode : String, fields : Array<TrackableFieds>, skip:Int = 0, take:Int = 50, completionHandler: @escaping (Result<Array<TrackableModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "geocaches/\(cacheCode)/trackables")
        query.add(fields: fields)
        query.add(skip: skip, take: take)
        GCApi.shared().getData(url: query, parseClass: Array<TrackableModel>.self, payload: "") { (result) in
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

    static func getUserTrackables(userRef : String? = nil, getType: TrackableGetType = .usersInventory, fields : Array<TrackableFieds>, skip:Int = 0, take:Int = 50,  completionHandler: @escaping (Result<Array<TrackableModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "trackables/\(userRef ?? "")")
        query.addTrackableGetType(trackableType: getType)
        query.add(fields: fields)
        query.add(skip: skip, take: take)
        GCApi.shared().getData(url: query, parseClass: Array<TrackableModel>.self, payload: "") { (result) in
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

    static func searchTrackables(trackables : Array<String>, fields : Array<TrackableFieds>, completionHandler: @escaping (Result<Array<TrackableModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "trackables")
        query.add(fields: fields)
        query.addRefCodes(refCodes: trackables)
        GCApi.shared().getData(url: query, parseClass: Array<TrackableModel>.self, payload: "") { (result) in
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
