// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public class GithubGist: Object {
    public dynamic var url = ""
    public dynamic var gistID = ""
    public dynamic var htmlURL = ""
    public dynamic var gistPublic = false
    public dynamic var gistDescription = ""
    public dynamic var comments = 0
    public dynamic var commentsURL = ""
    public dynamic var truncated = false

    public dynamic var owner: GithubUser?

    public override class func primaryKey() -> String {
        return "gistID"
    }
}
