// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public class GithubAccount: Object {
    public dynamic var avatarURL = ""
    public dynamic var bio = ""
    public dynamic var blog = ""
    public dynamic var collaborators = 0
    public dynamic var company = ""
//    public dynamic var createdAt = 0
    public dynamic var email = ""
    public dynamic var followers = 0
    public dynamic var following = 0
    public dynamic var hireable = false
    public dynamic var htmlURL = ""
    public dynamic var userID = ""
    public dynamic var location = ""
    public dynamic var login = ""
    public dynamic var name = ""
    public dynamic var ownedPrivateRepos = 0
    public dynamic var privateGists = 0
    public dynamic var publicGists = 0
    public dynamic var publicRepos = 0
    public dynamic var siteAdmin = 0
    public dynamic var totalPrivateRepos = 0
    public dynamic var type = ""
//    public dynamic var updatedAt = 0
    public dynamic var url = ""
    
    public var followingUsers = List<GithubUser>()
    public var followerUsers = List<GithubUser>()
    public var gists = List<GithubGist>()
    
    public override class func primaryKey() -> String {
        return "userID"
    }
}
