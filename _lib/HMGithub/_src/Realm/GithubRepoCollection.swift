// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public class GithubRepoCollection: Object {
    public dynamic var userID = ""
    
    public var publicRepos = List<GithubRepo>()
    public var privateRepos = List<GithubRepo>()

    public override class func primaryKey() -> String {
        return "userID"
    }
}

