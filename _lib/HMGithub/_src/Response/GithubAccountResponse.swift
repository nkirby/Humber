// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import Janus

import HMCore

// =======================================================

public struct GithubAccountResponse: JSONDecodable {
    public let avatarURL: String
    public let bio: String
    public let blog: String
    public let collaborators: Int
    public let company: String
    public let createdAt: String
    public let diskUsage: Int
    public let email: String
    public let eventsURL: String
    public let followers: Int
    public let followersURL: String
    public let following: Int
    public let followingURL: String
    public let gistsURL: String
    public let gravatarID: String
    public let hireable: Bool
    public let htmlURL: String
    public let userID: String
    public let location: String
    public let login: String
    public let name: String
    public let organizationsURL: String
    public let ownedPrivateRepos: Int
    public let plan: GithubUserPlanResponse?
    public let privateGists: Int
    public let publicGists: Int
    public let publicRepos: Int
    public let receivedEventsURL: String
    public let reposURL: String
    public let siteAdmin: Int
    public let starredURL: String
    public let subscriptionsURL: String
    public let totalPrivateRepos: Int
    public let type: String
    public let updatedAt: String
    public let url: String
    
    public init?(json: JSONValue<JSONDictionary>) {
        guard let login = json["login"].stringValue() else {
            return nil
        }
        
        if let userID = json["id"].to(String.self) {
            self.userID = userID
        } else if let userID = json["id"].to(Int.self) {
            self.userID = "\(userID)"
        } else {
            self.userID = ""
        }

        self.avatarURL = json["avatar_url"].stringValue(defaultValue: "")
        self.bio = json["bio"].stringValue(defaultValue: "")
        self.blog = json["blog"].stringValue(defaultValue: "")
        self.collaborators = json["collaborators"].intValue(defaultValue: 0)
        self.company = json["company"].stringValue(defaultValue: "")
        self.createdAt = json["created_at"].stringValue(defaultValue: "")
        self.diskUsage = json["disk_usage"].intValue(defaultValue: 0)
        self.email = json["email"].stringValue(defaultValue: "")
        self.eventsURL = json["events_url"].stringValue(defaultValue: "")
        self.followers = json["followers"].intValue(defaultValue: 0)
        self.followersURL = json["followers_url"].stringValue(defaultValue: "")
        self.following = json["following"].intValue(defaultValue: 0)
        self.followingURL = json["following_url"].stringValue(defaultValue: "")
        self.gistsURL = json["gists_url"].stringValue(defaultValue: "")
        self.gravatarID = json["gravatar_id"].stringValue(defaultValue: "")
        self.hireable = json["hireable"].boolValue(defaultValue: false)
        self.htmlURL = json["html_url"].stringValue(defaultValue: "")
        self.location = json["location"].stringValue(defaultValue: "")
        self.login = login
        self.name = json["name"].stringValue(defaultValue: "")
        self.organizationsURL = json["organizations_url"].stringValue(defaultValue: "")
        self.ownedPrivateRepos = json["owned_private_repos"].intValue(defaultValue: 0)
        self.privateGists = json["private_gists"].intValue(defaultValue: 0)
        self.publicGists = json["public_gists"].intValue(defaultValue: 0)
        self.publicRepos = json["public_repos"].intValue(defaultValue: 0)
        self.receivedEventsURL = json["received_events_url"].stringValue(defaultValue: "")
        self.reposURL = json["repos_url"].stringValue(defaultValue: "")
        self.siteAdmin = json["site_admin"].intValue(defaultValue: 0)
        self.starredURL = json["starred_url"].stringValue(defaultValue: "")
        self.subscriptionsURL = json["subscriptions_url"].stringValue(defaultValue: "")
        self.totalPrivateRepos = json["total_private_repos"].intValue(defaultValue: 0)
        self.type = json["type"].stringValue(defaultValue: "")
        self.updatedAt = json["updated_at"].stringValue(defaultValue: "")
        self.url = json["url"].stringValue(defaultValue: "")
        
        if let planDict = json["plan"].jsonDictionaryValue() {
            self.plan = JSONParser.model(GithubUserPlanResponse.self).from(planDict)
        } else {
            self.plan = nil
        }
    }
}

// =======================================================

public struct GithubUserPlanResponse: JSONDecodable {
    public let collabtorators: Int
    public let name: String
    public let privateRepos: Int
    public let space: String
    
    public init?(json: JSONValue<JSONDictionary>) {
        self.collabtorators = json["collaborators"].intValue(defaultValue: 0)
        self.name = json["name"].stringValue(defaultValue: "")
        self.privateRepos = json["private_repos"].intValue(defaultValue: 0)
        self.space = json["space"].to(String.self) ?? ""
    }
}