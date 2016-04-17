// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public class GithubNotification: Object {
    public dynamic var notificationID = ""
    
    public dynamic var unread = false
    public dynamic var reason = ""
    public dynamic var title = ""
    public dynamic var subjectURL = ""
    public dynamic var latestCommentURL = ""
    public dynamic var type = ""
    
    public dynamic var repository: GithubRepo?

    public override class func primaryKey() -> String {
        return "notificationID"
    }
}
