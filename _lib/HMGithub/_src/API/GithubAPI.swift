// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import Janus
import Alamofire
import ReactiveCocoa

import HMCore

// =======================================================

public enum GithubAPIError: ErrorType {
    case NotLoggedIn
    case RequestError
    case InvalidResponse
    case Unknown
}

public class GithubAPI: NSObject {
    private let manager = Alamofire.Manager()
    private let userID: String
    private let token: GithubOAuthToken
    
    public init?(context: ServiceContext) {
        let query = GithubKeychainStoreQuery()
        guard context.userIdentifier != "anon",
            let dict = KeychainStore().keychainItem(query: query),
            let token = GithubOAuthToken(keychainItem: dict) else {
                return nil
        }
        
        self.userID = context.userIdentifier
        self.token = token
        
        super.init()
        
        self.setupManager()
    }
    
    private func setupManager() {
        
    }
    
// =======================================================
// MARK: - Generation
    
    private func request(method method: Alamofire.Method, endpoint: String, parameters: [String: AnyObject]?) -> SignalProducer<Alamofire.Request, GithubAPIError> {
        return SignalProducer { observer, disposable in
            if Config.routerLogging {
                print("\(method): \(endpoint)")
            }
            
            let headers = [
                "Accept": "application/vnd.github.v3+json",
                "Authorization": "token \(self.token.accessToken)"
            ]
            
            let url = "https://api.github.com" + endpoint
            let request = Alamofire.Manager.sharedInstance.request(method, url, parameters: parameters, encoding: ParameterEncoding.URL, headers: headers)
            
            observer.sendNext(request)
            observer.sendCompleted()
        }
    }
    
    private func enqueue(request request: Alamofire.Request) -> SignalProducer<AnyObject, GithubAPIError> {
        return SignalProducer { observer, disposable in
            request.responseJSON { response in
                switch response.result {
                case .Success(let value):
                    observer.sendNext(value)
                    observer.sendCompleted()
                    return
                    
                default:
                    break
                }
                
                observer.sendFailed(.RequestError)
            }
            
            disposable.addDisposable {
                request.cancel()
            }
        }
    }
    
    private func parse<T: JSONDecodable>(response response: AnyObject, toType type: T.Type) -> SignalProducer<T, GithubAPIError> {
        return SignalProducer { observer, disposable in
            if let dict = response as? JSONDictionary, let obj = JSONParser.model(type).from(dict) {
                observer.sendNext(obj)
                observer.sendCompleted()
            } else {
                observer.sendFailed(.InvalidResponse)
            }
        }
    }
    
    private func parseFeed<T: JSONDecodable>(response response: AnyObject, toType type: T.Type) -> SignalProducer<[T], GithubAPIError> {
        return SignalProducer { observer, disposable in
            if let arr = response as? JSONArray, let feed = JSONParser.models(type).from(arr) {
                observer.sendNext(feed)
                observer.sendCompleted()
            } else {
                observer.sendFailed(.InvalidResponse)
            }
        }
    }
    
// =======================================================
// MARK: - Request Performing
    
    public func enqueueAndParse<T: JSONDecodable>(request request: GithubRequest, toType type: T.Type) -> SignalProducer<T, GithubAPIError> {
        return self.request(method: request.method, endpoint: request.endpoint, parameters: request.parameters)
            .flatMap(.Latest) { self.enqueue(request: $0) }
            .flatMap(.Latest) { self.parse(response: $0, toType: type) }
    }
    
    public func enqueueAndParseFeed<T: JSONDecodable>(request request: GithubRequest, toType type: T.Type) -> SignalProducer<[T], GithubAPIError> {
        return self.request(method: request.method, endpoint: request.endpoint, parameters: request.parameters)
            .flatMap(.Latest) { self.enqueue(request: $0) }
            .flatMap(.Latest) { self.parseFeed(response: $0, toType: type) }
    }
}
