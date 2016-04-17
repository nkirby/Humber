// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public class GithubUser: Object {
    public dynamic var login = ""
    public dynamic var userID = ""
    public dynamic var url = ""
    public dynamic var type = ""
    public dynamic var siteAdmin = false

    public override class func primaryKey() -> String {
        return "userID"
    }
}
