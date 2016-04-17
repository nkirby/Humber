// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation

public enum StoredKey: String {
    case GithubClientID = "github_client_id"
    case GithubClientSecret = "github_client_secret"
    case GithubRedirectURI = "github_redirect_uri"
}

// =======================================================

public final class Keys: NSObject {
    private var keyStorage: [String: AnyObject] = {
        let path = Bundle.mainBundle().pathForResource("keys", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let dict = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
        return dict as! [String: AnyObject]
    }()
    
//    public func value(key key: StoredKey) -> AnyObject {
//        return self.keyStorage[key.rawValue]!
//    }
    
    public func value<T: Any>(key key: StoredKey, type: T.Type) -> T {
        return self.keyStorage[key.rawValue] as! T
    }
}
