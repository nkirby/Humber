// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

// =======================================================

public class GithubRoutes: NSObject {
    public static let followersTemplate = "followers/:username"
    public static func followers(username username: String) -> String {
        return "followers/\(username)"
    }
    
    public static let followingTemplate = "following/:userID"
    public static func following(userID userID: String) -> String {
        return "following/\(userID)"
    }
    
    public static let reposTemplate = "repos/:userID/:type"
    public static func repos(userID userID: String, type: String) -> String {
        return "repos/\(userID)/\(type)"
    }
    
    public static let gistsTemplate = "gists/:userID/:type"
    public static func gists(userID userID: String, type: String) -> String {
        return "gists/\(userID)/\(type)"
    }
    
    public static let singleIssueTemplate = "issues/:username/:repoName/issues/:issueNumber"
    public static func singleIssue(username username: String, repoName: String, number: Int) -> String {
        return "issues/\(username)/\(repoName)/issues/\(number)"
    }
    
    public static let singleRepoTemplate = "repos/:username/:repoName"
    public static func singleRepo(username username: String, repoName: String) -> String {
        return "repos/\(username)/\(repoName)"
    }
    
    public static let editOverview = "overview/edit"
}

