//
//  GCApi.swift
//  GeocachingApi
//
//  Created by Matti Mustonen on 01/10/2018.
//  Copyright © 2018 Mustcode. All rights reserved.
//

import UIKit
import AppAuth

public enum GCError: Error {
    case badURL
    case missingToken
    case notFound
    case userOptedOut
    case tooManyRequests(nextCall: Int)
    case noResponse
    case configurationMissing
    case unmappedHttpError(errorObject: UnmapperError)
    case networkError(reason: Error)
    case parsingError(reason: Error)
    case decodeError(reason: Error)
}

struct ApiParams {
    let url : String
    let redirectUrl: String
    let clientId:String
    let clientSecret:String
    let authorizeEndpoint: String
    let tokenEndpoint:String
}

public struct UnmapperError: Codable {
    var statusCode: Int?
    var statusMessage: String?
    var errorMessage: String?
}

public enum ApiType {
    case staging
    case production
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

@objc public class GCApi: NSObject {
    private static let GCdateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    private static let GCOldDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    private static let authStateKey = "authState"
    private var onGoingDatatasks:NSHashTable<URLSessionDataTask> = NSHashTable()

    func apiParamsForType(type: ApiType) -> ApiParams {
        guard let myDict = GCApi.gcapiPlist() as? Dictionary<String, String> else {
            assert(false, "plist missing")
            return ApiParams(url: "", redirectUrl: "", clientId: "", clientSecret: "", authorizeEndpoint: "", tokenEndpoint: "")
        }

        switch type {
        case .staging:
            return ApiParams(url: "staging.api.groundspeak.com",
                             redirectUrl: myDict["redirect_uri"] ?? "",
                             clientId: myDict["client_id_staging"] ?? "",
                             clientSecret: myDict["client_secret_staging"] ?? "",
                             authorizeEndpoint: "https://staging.geocaching.com/oauth/authorize.aspx",
                             tokenEndpoint: "https://oauth-staging.geocaching.com/token")
        case .production:
            return ApiParams(url: "api.groundspeak.com",
                             redirectUrl: myDict["redirect_uri"] ?? "",
                             clientId: myDict["client_id"] ?? "",
                             clientSecret: myDict["client_secret"] ?? "",
                             authorizeEndpoint: "https://www.geocaching.com/oauth/authorize.aspx",
                             tokenEndpoint: "https://oauth.geocaching.com/token")
        }
    }

    static let versionString : String = "/v1.0"

    private var apiType : ApiType?
    private static var sharedNetworkManager: GCApi = {
        let networkManager = GCApi()
        return networkManager
    }()

    @objc public var currentAuthorizationFlow: OIDExternalUserAgentSession?
    private var authState: OIDAuthState?
    private var oidConfiguration: OIDServiceConfiguration?

    public lazy var baseUrl : String = {
        guard let type = GCApi.shared().apiType else{
            assert(false, "Apitype is not set")
            return ""
        }
        let apiParams = apiParamsForType(type: type)
        return apiParams.url
    }()

    public var returnSuccessValuesInMainThread = true

    private var sessionManager: URLSession?

    static public func gcapiPlist() -> Dictionary<String, Any>? {
        guard let path = Bundle.main.path(forResource: "GCApiKeys", ofType: "plist"),
            let myDict = NSDictionary(contentsOfFile: path) as? Dictionary<String, Any> else {
                assert(false, "Plist missing")
                return nil
        }
        return myDict
    }

    public func configure(apiType: ApiType){
        self.apiType = apiType
        guard let type = GCApi.shared().apiType else{
            assert(false, "Apitype is not set")
            return
        }
        let apiParams = apiParamsForType(type: type)
        guard let authorizeEndpoint = URL(string: apiParams.authorizeEndpoint),
            let tokenEndpoint = URL(string: apiParams.tokenEndpoint)
            else{
                assertionFailure("Endpoint missing")
                return
        }

        oidConfiguration = OIDServiceConfiguration(authorizationEndpoint: authorizeEndpoint, tokenEndpoint: tokenEndpoint, registrationEndpoint: tokenEndpoint)
    }

    public func cancelRequests() {
        for task in self.onGoingDatatasks.allObjects  {
            task.cancel()
        }
    }

    @objc public class func shared() -> GCApi {
        if sharedNetworkManager.sessionManager == nil {
            let customConfiguration = URLSessionConfiguration.default
            if #available(iOS 13.0, *) {
                customConfiguration.allowsExpensiveNetworkAccess = true
                customConfiguration.allowsConstrainedNetworkAccess = true
            }
            customConfiguration.timeoutIntervalForRequest = 60
            customConfiguration.requestCachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            sharedNetworkManager.sessionManager = URLSession(configuration: customConfiguration)
        }

        return sharedNetworkManager
    }
    func isAuthorized() -> Bool {
        if self.authState == nil{
            _ = loadState()
        }
        return authState?.isAuthorized ?? false
    }

    func resolveViewController() -> UIViewController? {
        if UIApplication.shared.keyWindow?.rootViewController?.isKind(of: UITabBarController.self) ?? false, let tabBar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController, let selected = tabBar.selectedViewController {
            return selected
        }
        return UIApplication.shared.keyWindow?.rootViewController
    }

    public func authorize(completionHandler: @escaping (Result<Bool, GCError>) -> Void) {
        guard let viewController = resolveViewController() else {
            assert(false, "Viewcontroller was not found")
            return
        }
        guard let type = GCApi.shared().apiType,
            let serviceConf = self.oidConfiguration else{
                completionHandler(.failure(GCError.configurationMissing))
                return
        }

        let apiParams = apiParamsForType(type: type)
        let redirectUrl = URL(string: apiParams.redirectUrl) ?? URL(fileURLWithPath: "")
        

        let request = OIDAuthorizationRequest(configuration: serviceConf, clientId: apiParams.clientId, clientSecret: apiParams.clientSecret, scopes: ["*"], redirectURL: redirectUrl, responseType: OIDResponseTypeCode, additionalParameters: nil)
        if !self.loadState() {
            self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController, callback: { [weak self] (state, error) in

                if state != nil {
                    self?.authState = state
                    self?.authState?.stateChangeDelegate = self
                    self?.saveState()
                    completionHandler(.success(true))
                } else {
                    print("authorisation error \(String(describing: error))")
                    self?.authState = nil
                    completionHandler(.failure(.networkError(reason: error!)))
                }
            })
        }
    }

    @objc public func logout() {
        self.authState = nil
        UserDefaults.standard.set(nil, forKey: GCApi.authStateKey)
        UserDefaults.standard.synchronize()
    }

    func getData<T : Codable,U : Codable>(url: GCQueryBuilder, parseClass : T.Type, httpMethod: HTTPMethod = .get, payload:U, completionHandler: @escaping (Result<T, GCError>) -> Void) {
        if (authState == nil) {
            _ = loadState()
        }
        if !(authState?.isAuthorized ?? false) {
            authorize {[weak self] (result) in
                switch result {
                case .failure(_):
                    completionHandler(.failure(GCError.missingToken))
                case .success(let model):
                    print(model)
                    self?.getData(url: url, parseClass: parseClass, httpMethod: httpMethod, payload: payload, completionHandler: completionHandler)
                }
            }
        }
        guard let completeUrl = createUrl(urlBuilder: url.urlBuilder) else {
            completionHandler(.failure(GCError.badURL))
            return
        }
        authState?.stateChangeDelegate = self
        authState?.performAction(freshTokens: { (accessToken, idToken, error) in
            guard let accessToken = accessToken else {
                DispatchQueue.main.async {
                    completionHandler(.failure(GCError.missingToken))
                }
                return
            }
            var urlRequest = URLRequest(url: completeUrl)
            if !(payload is String) {
                let payloadResult = self.encode(object: payload)
                switch payloadResult {
                case .success(let data):
                    urlRequest.httpBody = data
                case .failure(let error):
                    completionHandler(.failure(error))
                    return
                }
                if let aData = urlRequest.httpBody {
                    print(String(data: aData, encoding: .utf8) as Any)
                }
            }
            urlRequest.httpMethod = httpMethod.rawValue
            print(urlRequest)
            print("Authorization bearer \(accessToken)")
            urlRequest.allHTTPHeaderFields = ["Authorization":"bearer \(accessToken)", "Content-Type":" application/json", "Accept": "application/json", "Content-Encoding":"deflate"] //"Accept-Encoding": "gzip, deflate", "Content-Encoding": "gzip", , "Accept": "application/json"
            let dataTask = self.sessionManager?.dataTask(with: urlRequest, completionHandler: { [weak self] (data, urlResponse, error) in
                if data?.count ?? 0 < 500 {
                    print(urlResponse?.description ?? "No description")
                }
                if let response = urlResponse as? HTTPURLResponse {
                    if response.statusCode == 204 {
                        DispatchQueue.main.async {
                            completionHandler(.success(true as! T))
                        }
                    } else if (200...299).contains(response.statusCode) {
                        self?.parseResponse(response: data, networkError: error, parseClass: parseClass, completionHandler: completionHandler)
                    } else if response.statusCode == 401 {
                        DispatchQueue.main.async {
                            completionHandler(.failure(GCError.missingToken))
                        }
                    } else if response.statusCode == 403 {
                        DispatchQueue.main.async {
                            completionHandler(.failure(GCError.userOptedOut))
                        }
                    } else if response.statusCode == 404 {
                        DispatchQueue.main.async {
                            completionHandler(.failure(GCError.notFound))
                        }
                    }
                    else if response.statusCode == 429 {
                        DispatchQueue.main.async {
                            let timeout = response.allHeaderFields.first(where: { (key, _) -> Bool in
                                return key as? String == "x-rate-limit-reset"
                            })
                            let nextCall: Int = timeout?.value as? Int ?? 60
                            completionHandler(.failure(GCError.tooManyRequests(nextCall: nextCall)))
                        }
                    }else {
                        DispatchQueue.main.async {
                            var unmappedError = UnmapperError(statusCode: 999, statusMessage: "Unknown error", errorMessage: "Please check the console")
                            if let dataObject = data, let errorObject = try? self?.decode(data: dataObject, parseClass: UnmapperError.self) {
                                unmappedError = errorObject
                            }
                            completionHandler(.failure(GCError.unmappedHttpError(errorObject: unmappedError)))
                        }
                        /*
                         {"statusCode":400,"statusMessage":"Bad Request","errorMessage":"Box value [[65.02475627493804,25.488366816551803],[64.99846933278688,25.452832906353592]] is not valid. Must match format of [[(upper left boundary coordinate)],[(bottom right boundary coordinate)]]"}
                         */
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(GCError.noResponse))
                    }
                }
            })
            if let task = dataTask {
                self.onGoingDatatasks.add(task)
            }
            dataTask?.resume()
        })

    }

    func createUrl(urlBuilder:URLComponents) -> URL? {
        var stringUrl = urlBuilder.string ?? ""
        stringUrl = stringUrl.replacingOccurrences(of: "+", with: "%2B")
        return URL(string: stringUrl)
    }

    func encode<T : Codable>(object:T) -> Result<Data, GCError> {
        do {
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            //2000-06-17T00:00:00.000
            dateFormatter.dateFormat = GCApi.GCdateFormat
            encoder.dateEncodingStrategy = .formatted(dateFormatter)

            let data = try encoder.encode(object)
            return .success(data)
        } catch let error {
            return .failure(GCError.decodeError(reason: error))
        }
    }

    func decode<T : Codable>(data: Data, parseClass : T.Type) throws -> T {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        //2000-06-17T00:00:00.000
        dateFormatter.dateFormat = GCApi.GCdateFormat
        let oldDateFormatter = DateFormatter()
        //2000-06-17T00:00:00.000
        oldDateFormatter.dateFormat = GCApi.GCOldDateFormat

        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            if let date =  dateFormatter.date(from: dateStr){
                return date
            } else if let date = oldDateFormatter.date(from: dateStr) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
        })

        let geocache = try decoder.decode(parseClass, from: data)
        return geocache
    }

    func parseResponse<T : Codable>(response : Data?, networkError : Error? , parseClass : T.Type, completionHandler: @escaping (Result<T, GCError>) -> Void) {
        if let data = response  {
            do {
                if parseClass == Data.self, let returnData = data as? T {
                    DispatchQueue.main.async {
                        completionHandler(.success(returnData))
                    }
                    return
                }
                let geocache = try self.decode(data: data, parseClass: T.self)
                if returnSuccessValuesInMainThread {
                    DispatchQueue.main.async {
                        completionHandler(.success(geocache))
                    }
                } else {
                    completionHandler(.success(geocache))
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(.failure(GCError.parsingError(reason:error)))
                }
            }
        } else {
            if let error = networkError{
                DispatchQueue.main.async {
                    completionHandler(.failure(GCError.networkError(reason:error)))
                }
            }

        }

    }

    func saveState() {
        var data: Data? = nil

        if let authState = self.authState {
            if #available(iOS 12.0, *) {
                data = try! NSKeyedArchiver.archivedData(withRootObject: authState, requiringSecureCoding: false)
            } else {
                data = NSKeyedArchiver.archivedData(withRootObject: authState)
            }
        }

        UserDefaults.standard.set(data, forKey: GCApi.authStateKey)
        UserDefaults.standard.synchronize()

        print("Authorization state has been saved.")
    }

    func loadState() -> Bool{
        guard let data = UserDefaults.standard.object(forKey: GCApi.authStateKey) as? Data else {
            return false
        }

        var authState: OIDAuthState? = nil

        if #available(iOS 12.0, *) {
            authState = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? OIDAuthState
        } else {
            authState = NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDAuthState
        }

        if let authState = authState {
            print("Authorization state has been loaded.")
            self.authState = authState
            self.authState?.stateChangeDelegate = self
            return true
        }
        return false
    }
}

extension GCApi: URLSessionDelegate {

}

extension GCApi: OIDAuthStateChangeDelegate {
    public func didChange(_ state: OIDAuthState) {
        if state.isAuthorized{
            self.authState = state
            print(state.refreshToken ?? "no refresh token")
            print(state.lastTokenResponse?.accessToken ?? "no access token")
            print(state.lastTokenResponse?.idToken ?? "no id token")
            self.saveState()
        }
    }
}

