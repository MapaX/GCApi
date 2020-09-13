//
//  QueryBuilder.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 23.3.2020.
//  Copyright © 2020 Mustcode. All rights reserved.
//

import UIKit
import CoreLocation

class GCQueryBuilder: NSObject {
    var urlBuilder = URLComponents()
    required init(basePath:String) {
        urlBuilder.scheme = "https"
        urlBuilder.host = GCApi.shared().baseUrl
        urlBuilder.path = "\(GCApi.versionString)/\(basePath)"
        urlBuilder.queryItems = []
    }

    func addFragment(key:String, value:String) {
        urlBuilder.queryItems?.removeAll(where: { (item) -> Bool in
            item.name == key
        })
        urlBuilder.queryItems?.append(URLQueryItem(name: key, value: value))
    }

    func addQueryFragment(key:String, value:String) {
        var queryParams = ""
        if let queryFragment = urlBuilder.queryItems?.first(where: { (item) -> Bool in
            item.name == "q"
        }), let fragmentValue = queryFragment.value {
            queryParams = fragmentValue
        }
        queryParams.append("+\(key):\(value)")
        addFragment(key: "q", value: queryParams)
    }

    func addBoundingBox(upperLeft:CLLocationCoordinate2D, lowerRight:CLLocationCoordinate2D) {
        addFragment(key: "q", value: "box:\(String(upperLeft:upperLeft,lowerRight:lowerRight))")
    }

    func add(centerPoint:CLLocationCoordinate2D, radiusMiles:Int) {
        addFragment(key: "q", value: "location:\(centerPoint.gcApiCoordinateString())+radius:\(String(radiusMiles))mi")
    }

    func add(upperLeft:CLLocationCoordinate2D, lowerRight:CLLocationCoordinate2D) {
        addFragment(key: "q", value: "box:\(String(upperLeft:upperLeft,lowerRight:lowerRight))")
    }

    func addType<T : RawRepresentable>(fields : Array<T>)  {
        addFragment(key: "type", value:createFieldArray(fields: fields) )
    }

    func addTypes<T : RawRepresentable>(fields : Array<T>)  {
        addFragment(key: "types", value:createFieldArray(fields: fields) )
    }

    func expandAttributes<T : RawRepresentable>(attributes:Array<T>) {
        guard var fieldsString = getParameter(param: "fields") else {
            assert(false, "You must first call add fields")
            return
        }
        let attributeString = [GeocacheFields.attributes.rawValue, "[", createFieldArray(fields: attributes), "]"].joined()
        fieldsString = fieldsString.replacingOccurrences(of: GeocacheFields.attributes.rawValue, with: attributeString)
        addFragment(key: "fields", value: fieldsString)
    }
    
    func addIsLite(isLite:Bool) {
        addFragment(key: "lite", value: isLite.description)
    }

    func addTrackableGetType(trackableType:TrackableGetType) {
        addFragment(key: "type", value: trackableType.rawValue.description)
    }

    func add<T : RawRepresentable>(fields : Array<T>)  {
        addFragment(key: "fields", value:createFieldArray(fields: fields) )
    }

    func addExludeFound(userId:String) {
        addQueryFragment(key: "fby", value: "not(\(userId))")
    }
    
    func add(terrain from:Int, to:Int)  {
        addQueryFragment(key: "terr", value:"\(from)-\(to)")
    }

    func add(difficulty from:Int, to:Int)  {
        addQueryFragment(key: "diff", value:"\(from)-\(to)")
    }

    func add<T : RawRepresentable>(sizes : Array<T>)  {
        addQueryFragment(key: "size", value:createFieldArray(fields: sizes) )
    }

    func add(favourite from:Int)  {
        addQueryFragment(key: "minFav", value:"\(from)")
    }

    func addRefCodes(refCodes : Array<String>)  {
        addFragment(key: "referenceCodes", value:refCodes.joined(separator: ","))
    }

    func addUserNames(userNames : Array<String>)  {
        addFragment(key: "usernames", value:userNames.joined(separator: ","))
    }

    //expand=geocachelogs:5,trackables:
    func add(logs:Int = 0, logFields:Array<LogFieds> = LogFieds.allCases, trackables: Int = 0, trackableFields:Array<TrackableFieds> = TrackableFieds.allCases) {
        guard var fieldsString = getParameter(param: "fields") else {
            assert(false, "You must first call add fields")
            return
        }
        var expandStrings:Array<String> = []

        if logs > 0 {
            fieldsString.append(contentsOf: ",geocachelogs[\(createFieldArray(fields: logFields))]")
            expandStrings.append("geocachelogs:\(logs)")
        }
        if trackables > 0 {
            fieldsString.append(contentsOf: ",trackables[\(createFieldArray(fields: trackableFields))]")
            expandStrings.append("trackables:\(trackables)")
        }
        if expandStrings.count > 0 {
            addFragment(key: "fields", value: fieldsString)
            addFragment(key: "expand", value: expandStrings.joined(separator: ","))
        }
    }

    func add(skip:Int = 0, take:Int = 0) {
        if skip > 0{
            addFragment(key: "skip", value: skip.description)
        }
        if take > 0{
            addFragment(key: "take", value: take.description)
        }
    }

    private func createFieldArray<T : RawRepresentable>(fields : Array<T>) -> String {

        return fields.map{ if let value = $0.rawValue as? String {
            return value
        } else if let value = $0.rawValue as? Int {
            return value.description
        } else {
            return ""
        }

        }.joined(separator: ",")
    }

    private func getParameter(param: String) -> String? {
        if let queryItems = (urlBuilder.queryItems) {
            return queryItems.filter({ (item) in item.name == param }).first?.value ?? nil
        }
        return nil
    }
}

extension String {
    init(upperLeft:CLLocationCoordinate2D, lowerRight:CLLocationCoordinate2D) {
        self =  ["[", upperLeft.gcApiCoordinateString(), ",", lowerRight.gcApiCoordinateString(), "]"].joined()
    }
}

extension CLLocationCoordinate2D {
    func gcApiCoordinateString() -> String {
        return ["[", NSString(format: "%.6f", latitude) as String, ",", NSString(format: "%.6f", longitude)  as String, "]"].joined()
    }
}
