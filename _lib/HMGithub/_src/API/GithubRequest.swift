// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import Alamofire

public struct GithubRequest {
    public let method: Alamofire.Method
    public let endpoint: String
    public let parameters: [String: AnyObject]?
    
    public init(method: Alamofire.Method, endpoint: String, parameters: [String: AnyObject]?) {
        self.method = method
        self.endpoint = endpoint
        self.parameters = parameters
    }
}

