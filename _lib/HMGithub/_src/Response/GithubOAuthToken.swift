// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import Janus

import HMCore

// =======================================================

public struct GithubOAuthToken: JSONDecodable {
    public let accessToken: String
    public let scope: String
    public let tokenType: String
    
    public var keychainItem: [String: AnyObject] {
        return [
            "access_token": self.accessToken,
            "scope": self.scope,
            "token_type": self.tokenType
        ]
    }
    
    public init?(json: JSONValue<JSONDictionary>) {
        guard let accessToken = json["access_token"].stringValue() else {
            return nil
        }
        
        self.accessToken = accessToken
        self.scope = json["scope"].stringValue(defaultValue: "")
        self.tokenType = json["token_type"].stringValue(defaultValue: "")
    }
    
    public init?(keychainItem: [String: AnyObject]) {
        let json = JSONValue<JSONDictionary>(value: keychainItem)
        self.init(json: json)
    }
}
