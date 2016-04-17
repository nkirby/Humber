// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public class GithubOverview: Object {
    public dynamic var userID = ""
    
    public var items = List<GithubOverviewItem>()
    
    public override class func primaryKey() -> String {
        return "userID"
    }
}
