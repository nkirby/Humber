// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public class GithubIssueCollection: Object {
    public dynamic var userID = ""
    
    public var issues = List<GithubIssue>()
    
    public override class func primaryKey() -> String {
        return "userID"
    }
}

