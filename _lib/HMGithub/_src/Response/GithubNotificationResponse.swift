// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import Janus

import HMCore

// =======================================================

public struct GithubNotificationResponse: JSONDecodable {
    public let notificationID: String
    public let unread: Bool
    public let reason: GithubNotificationReason
    public let title: String
    public let subjectURL: String
    public let latestCommentURL: String
    public let type: GithubNotificationType
    
    public let repository: GithubRepoResponse

    // updatedAt
    // lastReadAt
    
    public init?(json: JSONValue<JSONDictionary>) {
        if let notificationID = json["id"].to(String.self) {
            self.notificationID = notificationID
        } else if let notificationID = json["id"].to(Int.self) {
            self.notificationID = "\(notificationID)"
        } else {
            print("notif :(")
            return nil
        }
        
        self.unread = json["unread"].boolValue(defaultValue: false)
        self.title = json["subject"]["title"].stringValue(defaultValue: "")
        self.subjectURL = json["subject"]["url"].stringValue(defaultValue: "")
        self.latestCommentURL = json["subject"]["latest_comment_url"].stringValue(defaultValue: "")
        
        if let type = json["subject"]["type"].stringValue(), let notifType = GithubNotificationType(rawValue: type.lowercaseString) {
            self.type = notifType
        } else {
            print("type :(")
            return nil
        }
        
        if let reason = GithubNotificationReason(rawValue: json["reason"].stringValue(defaultValue: "").lowercaseString) {
            self.reason = reason
        } else {
            print("reason :(")
            return nil
        }
        
        if let dict = json["repository"].jsonDictionaryValue(), let repo = JSONParser.model(GithubRepoResponse.self).from(dict) {
            self.repository = repo
        } else {
            print("repo :(")
            return nil
        }
    }
}
