//
//  User.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 07/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit


enum UserFields : String, CaseIterable {
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

enum MembershipLevelId: Int, Codable {
    case unknown = 0
    case basic = 1
    case charter = 2
    case premium = 3
}

enum SouvenirFields : String, CaseIterable {
    case description = "description"
    case imagePath = "imagePath"
    case thumbImagePath = "thumbImagePath"
    case foundDateUtc = "foundDateUtc"
    case url = "url"
}

@objc class UserModel : NSObject, Codable {
    let referenceCode: String?
    let findCount: Int?
    let hideCount: Int?
    let favoritePoints: Int?
    let username: String?
    let membershipLevelId: MembershipLevelId?
    let avatarUrl: URL?
    let bannerUrl: String?
    let url: URL?
    let profileText: String?
    let homeCoordinates: CoordinatesModel?
    let geocacheLimits: CacheLimitsModel?
}

class CacheLimitsModel: NSObject, Codable {
    let liteCallsRemaining: Int?
    let fullCallsRemaining:Int?
}

@objc class MembershipNameModel: NSObject, Codable, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(id, forKey: "id")
    }

    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        id = coder.decodeObject(forKey: "id") as? Int ?? 0
    }

    let id: Int?
    @objc let name:String?
    @objc func getUId() -> NSNumber? {
        return (id ?? 0) as NSNumber
    }
}

class GCUser: NSObject {

    static func getUserInfo(referenceCode:String = "me", fields : Array<UserFields>, completionHandler: @escaping (Result<UserModel, GCError>) -> Void) {
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

    static func getUsersInfo(referenceCodes:Array<String> = [], userNames:Array<String> = [], fields : Array<UserFields>, completionHandler: @escaping (Result<Array<UserModel>, GCError>) -> Void) {
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

    static func getMembershipTypes(completionHandler: @escaping (Result<Array<MembershipNameModel>, GCError>) -> Void) {
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

    static func getUserLists(referenceCode:String, fields : Array<ListFields>, completionHandler: @escaping (Result<Array<ListModel>, GCError>) -> Void) {
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
