// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public class GithubNotificationCollection: Object {
    public dynamic var userID = ""
    
    public var notifications = List<GithubNotification>()
    
    public override class func primaryKey() -> String {
        return "userID"
    }
}
