// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public class GithubRepo: Object {
    public dynamic var repoID = ""
    public dynamic var name = ""
    public dynamic var fullName = ""
    public dynamic var repoPrivate = false
    public dynamic var htmlURL = ""
    public dynamic var repoDescription = ""
    public dynamic var fork = false
    public dynamic var gitURL = ""
    public dynamic var sshURL = ""
    public dynamic var svnURL = ""
    public dynamic var homepage = ""
    public dynamic var size = 0
    public dynamic var stargazersCount = 0
    public dynamic var language = ""
    public dynamic var hasIssues = true
    public dynamic var hasDownloads = true
    public dynamic var hasWiki = true
    public dynamic var hasPages = true
    public dynamic var forksCount = 0
    public dynamic var openIssuesCount = 0
    public dynamic var forks = 0
    public dynamic var openIssues = 0
    public dynamic var watchers = 0
    public dynamic var defaultBranch = ""
    public dynamic var permissionsAdmin = false
    public dynamic var permissionsPush = false
    public dynamic var permissionsPull = false

    public dynamic var owner: GithubUser?
    
    public override class func primaryKey() -> String {
        return "repoID"
    }
}
