// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import UIKit
import ReactiveCocoa
import Alamofire
import Janus

import HMCore

public struct GithubLoginRequest {
    public let state: String
    public let requestURL: String
    
    internal init?(clientID: String, redirectURI: String) {
        let uuid = NSUUID().UUIDString
        self.state = uuid
        
        guard let redirectURI = redirectURI.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()) else {
            return nil
        }
        
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&scope=user,repo&state=\(uuid)"
        self.requestURL = urlString
    }
}

public enum GithubLoginError: ErrorType {
    case Unknown
    case UnableToLogin
}

public protocol GithubLoginRequestProviding {
    var loginSignal: Signal<Bool, GithubLoginError> { get }
    func createLoginRequest() throws -> GithubLoginRequest
}

public protocol GithubLoginURLHandling {
    func handleOpenURL(url url: NSURL) -> Bool
}

public final class GithubLoginAPI: NSObject, GithubLoginRequestProviding, GithubLoginURLHandling {
    public let loginSignal: Signal<Bool, GithubLoginError>
    private let loginObserver: Observer<Bool, GithubLoginError>

    private var currentRequest: GithubLoginRequest?
    
    public override init() {
        let (signal, observer) = Signal<Bool, GithubLoginError>.pipe()
        self.loginSignal = signal
        self.loginObserver = observer
        
        super.init()
    }
    
    public func createLoginRequest() throws -> GithubLoginRequest {
        let keys = Keys()
        let clientID = keys.value(key: StoredKey.GithubClientID, type: String.self)
        let redirectURI = keys.value(key: StoredKey.GithubRedirectURI, type: String.self)
        
        guard let request = GithubLoginRequest(clientID: clientID, redirectURI: redirectURI) else {
            throw GithubLoginError.Unknown
        }
        
        self.currentRequest = request
        return request
    }
    
    public func handleOpenURL(url url: NSURL) -> Bool {
        guard let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false),
            let query = components.queryItems else {
                return false
        }
        
        if !url.absoluteString.containsString("://authorize?") {
            return false
        }
        
        for item in query {
            if item.name.lowercaseString == "code" {
                self.getOAuthToken(code: item.value!)
                return true
            }
        }
        
        return false
    }
    
    private func getOAuthToken(code code: String) {        
        let keys = Keys()
        let clientID = keys.value(key: StoredKey.GithubClientID, type: String.self)
        let clientSecret = keys.value(key: StoredKey.GithubClientSecret, type: String.self)
        let redirectURI = keys.value(key: StoredKey.GithubRedirectURI, type: String.self)

        guard let state = self.currentRequest?.state else {
            self.loginObserver.sendFailed(.Unknown)
            return
        }
        
        let params = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "redirectURI": redirectURI,
            "state": state,
            "code": code
        ]
        
        let headers = [
            "Accept": "application/json"
        ]
        
        let request = Alamofire.Manager.sharedInstance.request(.POST, "https://github.com/login/oauth/access_token", parameters: params, encoding: ParameterEncoding.URL, headers: headers)
        
        request.responseJSON { response in
            switch response.result {
            case .Success(let value):
                if let dict = value as? JSONDictionary, let token = JSONParser.model(GithubOAuthToken.self).from(dict) {
                    let query = GithubKeychainStoreQuery()
                    KeychainStore().saveKeychainItem(token.keychainItem, forQuery: query)
                    
                    self.getUserInfo(token: token)
                    return
                }
                
            default:
                break
            }
            
            self.loginObserver.sendFailed(.UnableToLogin)
        }
    }

    private func getUserInfo(token token: GithubOAuthToken) {
        let headers = [
            "Accept": "application/vnd.github.v3+json",
            "Authorization": "token \(token.accessToken)"
        ]
        
        let request = Alamofire.Manager.sharedInstance.request(.GET, "https://api.github.com/user", parameters: nil, encoding: ParameterEncoding.URL, headers: headers)
        request.responseJSON { response in
            switch response.result {
            case .Success(let value):
                if let dict = value as? JSONDictionary, let obj = JSONParser.model(GithubUserResponse.self).from(dict) {
                    self.loginObserver.sendNext(true)
                    
                    ServiceController.sharedController.login(userID: obj.userID)
                    return
                }
                
            default:
                break
            }
            
            self.loginObserver.sendFailed(.UnableToLogin)
        }
    }
}
