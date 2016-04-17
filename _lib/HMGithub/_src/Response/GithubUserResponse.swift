// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import Janus

import HMCore

// =======================================================

public struct GithubUserResponse: JSONDecodable {
    public let login: String
    public let userID: String
    public let avatarURL: String
    public let gravatarID: String
    public let url: String
    public let followersURL: String
    public let followingURL: String
    public let gistsURL: String
    public let starredURL: String
    public let subscriptionsURL: String
    public let organizationsURL: String
    public let reposURL: String
    public let eventsURL: String
    public let receivedEventsURL: String
    public let type: String
    public let siteAdmin: Bool
    
    public init?(json: JSONValue<JSONDictionary>) {
        guard let login = json["login"].stringValue() else {
            return nil
        }
        
        self.login = login
        
        if let userID = json["id"].to(String.self) {
            self.userID = userID
        } else if let userID = json["id"].to(Int.self) {
            self.userID = "\(userID)"
        } else {
            self.userID = ""
        }

        self.avatarURL = json["avatar_url"].stringValue(defaultValue: "")
        self.gravatarID = json["gravatar_id"].stringValue(defaultValue: "")
        self.url = json["url"].stringValue(defaultValue: "")
        self.followersURL = json["followers_url"].stringValue(defaultValue: "")
        self.followingURL = json["following_url"].stringValue(defaultValue: "")
        self.gistsURL = json["gists_url"].stringValue(defaultValue: "")
        self.starredURL = json["starred_url"].stringValue(defaultValue: "")
        self.subscriptionsURL = json["subscriptions_url"].stringValue(defaultValue: "")
        self.organizationsURL = json["organizations_url"].stringValue(defaultValue: "")
        self.reposURL = json["repos_url"].stringValue(defaultValue: "")
        self.eventsURL = json["events_url"].stringValue(defaultValue: "")
        self.receivedEventsURL = json["received_events_url"].stringValue(defaultValue: "")
        self.type = json["type"].stringValue(defaultValue: "")
        self.siteAdmin = json["site_admin"].boolValue(defaultValue: false)
    }
}
