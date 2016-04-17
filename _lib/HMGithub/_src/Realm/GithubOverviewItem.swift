// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public class GithubOverviewItem: Object {
    public dynamic var itemID = ""
    
    public dynamic var sortOrder = 0
    public dynamic var type = ""
    public dynamic var title = ""
    public dynamic var value = 0
    public dynamic var query = ""
    public dynamic var repoName = ""
    public dynamic var repoOwner = ""
    public dynamic var action = ""
    public dynamic var threshold = -1
    
    public override class func primaryKey() -> String {
        return "itemID"
    }
}
