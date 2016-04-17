// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public class GithubIssue: Object {
    public dynamic var issueID = ""

    public dynamic var url = ""
    public dynamic var issueNumber = 0
    public dynamic var title = ""
    public dynamic var state = ""
    public dynamic var locked = false
    public dynamic var milestone = ""
    public dynamic var comments = 0
    public dynamic var body = ""
    
    public dynamic var user: GithubUser?
    public dynamic var assignee: GithubUser?
    public dynamic var repository: GithubRepo?

    public override class func primaryKey() -> String {
        return "issueID"
    }
}

