//
//  List.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 07/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit

public enum ListFields : String, CaseIterable {
    case referenceCode = "referenceCode"
    case lastUpdatedDateUtc = "lastUpdatedDateUtc"
    case createdDateUtc = "createdDateUtc"
    case name = "name"
    case count = "count"
    case findCount = "findCount"
    case ownerCode = "ownerCode"
    case description = "description"
    case typeId = "typeId"
    case isShared = "isShared"
    case isPublic = "isPublic"
    case url = "url"
}

public enum ListGeocacheFields : String, CaseIterable {
    case referenceCode = "referenceCode"
    case name = "name"
}

public enum ListType : Int, Codable {
    case PocketQuery = 1
    case Bookmark = 2
    case Ignore = 3
    case Watch = 4
    case Favorites = 5
}
//    the type of lists to return. options are fl (favorites list), wl (watch list), il (ignore list), bm (bookmark list), pq (pocket query)
public enum ListTypeName : String, Codable, CaseIterable {
    case PocketQuery = "pq"
    case Bookmark = "bm"
    case Ignore = "il"
    case Watch = "wl"
    case Favorites = "fl"
}


public class ListModel: Codable {
    public let referenceCode:String? //uniquely identifies the list    No    No
    public let createdDateUtc:Date? //when the list was created in UTC    No    No
    public let lastUpdatedDateUtc:Date? //when the list was last updated in UTC. for pocket queries, this represents the last time the query was generated    No    No
    public let name:String?  //display name of the list    Yes    Yes
    public let count:Int? //how many geocaches are in the list    No    No
    public let findCount:Int? //how many of the geocaches in list are found    No    No
    public let ownerCode:String? //identifier of the user who owns the list    No    No
    public let description:String? //text about the list    No    Yes
    public let typeId: ListType? //type of the list (see List Types for more info)    No (defaults to bookmark list type)    No
    public let isShared: Bool? //if the list is accessible through a direct link    Yes    Yes
    public let isPublic: Bool? //if the list is accessible to everyone without a direct link    Yes    Yes
    public let url: String? //geocaching.com web page associated with list (no url returned for pocket query types)    No    No
}

public class BulkFailureObject: Codable {
    public let referenceCode: String?
    public let message: String?
    public let statusCode: Int?
}

public class BulkResponseObject: Codable {
    public let successes: Array<String>?
    public let failures: Array<BulkFailureObject>?
}

public class GCList: NSObject {
    ///identifier of the list (ignore, favorites, or watch can be used as aliases in place of the reference codes to get the calling user's ignore list and watch list).
    public static func getList(referenceCode : String, fields : Array<ListFields>, completionHandler: @escaping (Result<ListModel, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "lists/\(referenceCode)")
        query.add(fields: fields)
        GCApi.shared().getData(url: query, parseClass: ListModel.self, payload: "") { (result) in
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

    public static func getUsersList(referenceCode : String = "me",skip:Int = 0, take:Int = 0, listTypes:Array<ListTypeName>, fields : Array<ListFields>, completionHandler: @escaping (Result<Array<ListModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "users/\(referenceCode)/lists")
        query.add(fields: fields)
        query.addTypes(fields: listTypes)
        query.add(skip: skip, take: take)
        GCApi.shared().getData(url: query, parseClass: Array<ListModel>.self, payload: "") { (result) in
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

    public static func getPocketQuery(referenceCode:String, skip:Int = 0, take:Int = 50, fields : Array<GeocacheFields>, completionHandler: @escaping (Result<Array<GeocacheModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "lists/\(referenceCode)/geocaches")
        query.add(skip: skip, take: take)
        query.add(fields: fields)
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

    public static func getPocketQueryZipped(referenceCode:String, completionHandler: @escaping (Result<Data, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "lists/\(referenceCode)/geocaches/zipped")

        GCApi.shared().getData(url: query, parseClass: Data.self, payload: "") { (result) in
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


    public static func addCachesToList(caches : Array<String>, listGuid:String, completionHandler: @escaping (Result<BulkResponseObject, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "lists/\(listGuid)/bulkgeocaches")
        GCApi.shared().getData(url: query, parseClass: BulkResponseObject.self, payload: caches) { (result) in
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
