//
//  User.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 07/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit


public enum UserFields : String, CaseIterable {
    case referenceCode = "referenceCode"
    case findCount = "findCount"
    case hideCount = "hideCount"
    case favoritePoints = "favoritePoints"
    case username = "username"
    case membershipLevelId = "membershipLevelId"
    case avatarUrl = "avatarUrl"
    case bannerUrl = "bannerUrl"
    case url = "url"
    case profileText = "profileText"
    case homeCoordinates = "homeCoordinates"
    case geocacheLimits = "geocacheLimits"
}

public enum MembershipLevelId: Int, Codable {
    case unknown = 0
    case basic = 1
    case charter = 2
    case premium = 3
}

public enum SouvenirFields : String, CaseIterable {
    case description = "description"
    case imagePath = "imagePath"
    case thumbImagePath = "thumbImagePath"
    case foundDateUtc = "foundDateUtc"
    case url = "url"
}

@objc public class UserModel : NSObject, Codable {
    public let referenceCode: String?
    public let findCount: Int?
    public let hideCount: Int?
    public let favoritePoints: Int?
    public let username: String?
    public let membershipLevelId: MembershipLevelId?
    public let avatarUrl: URL?
    public let bannerUrl: String?
    public let url: URL?
    public let profileText: String?
    public let homeCoordinates: CoordinatesModel?
    public let geocacheLimits: CacheLimitsModel?
}

public class CacheLimitsModel: NSObject, Codable {
    public let liteCallsRemaining: Int?
    public let fullCallsRemaining:Int?
}

@objc public class MembershipNameModel: NSObject, Codable, NSCoding {
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(id, forKey: "id")
    }

    public required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        id = coder.decodeObject(forKey: "id") as? Int ?? 0
    }

    public let id: Int?
    @objc public let name:String?
    @objc public func getUId() -> NSNumber? {
        return (id ?? 0) as NSNumber
    }
}

public class GCUser: NSObject {

    public static func getUserInfo(referenceCode:String = "me", fields : Array<UserFields>, completionHandler: @escaping (Result<UserModel, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "users/\(referenceCode)")
        query.add(fields: fields)
        GCApi.shared().getData(url: query, parseClass: UserModel.self, payload: "") { (result) in
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

    public static func getUsersInfo(referenceCodes:Array<String> = [], userNames:Array<String> = [], fields : Array<UserFields>, completionHandler: @escaping (Result<Array<UserModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "users")
        query.add(fields: fields)
        if referenceCodes.count > 0{
            query.addRefCodes(refCodes: referenceCodes)
        }
        if userNames.count > 0 {
            query.addUserNames(userNames: userNames)
        }
        GCApi.shared().getData(url: query, parseClass: Array<UserModel>.self, payload: "") { (result) in
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

    public static func getMembershipTypes(completionHandler: @escaping (Result<Array<MembershipNameModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "membershiplevels")

        GCApi.shared().getData(url: query, parseClass: Array<MembershipNameModel>.self, payload: "") { (result) in
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

    public static func getUserLists(referenceCode:String, fields : Array<ListFields>, completionHandler: @escaping (Result<Array<ListModel>, GCError>) -> Void) {
        let query = GCQueryBuilder(basePath: "users/\(referenceCode)/lists")
        query.add(fields: fields)
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
}
