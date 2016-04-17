// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public struct GithubNotificationModel {
    public let notificationID: String
    
    public let unread: Bool
    public let reason: GithubNotificationReason
    public let title: String
    public let subjectURL: String
    public let latestCommentURL: String
    public let type: GithubNotificationType
    
    public let repository: GithubRepoModel

// =======================================================
// MARK: - Response -> Model
    
    public init(response: GithubNotificationResponse) {
        self.notificationID = response.notificationID

        self.unread = response.unread
        self.reason = response.reason
        self.title = response.title
        self.subjectURL = response.subjectURL
        self.latestCommentURL = response.latestCommentURL
        self.type = response.type
        
        self.repository = GithubRepoModel(response: response.repository)
    }
    
// =======================================================
// MARK: - Object -> Model
    
    public init?(object: GithubNotification) {
        self.notificationID = object.notificationID
        
        self.unread = object.unread
        self.reason = GithubNotificationReason(rawValue: object.reason) ?? GithubNotificationReason.Subscribed
        self.title = object.title
        self.subjectURL = object.subjectURL
        self.latestCommentURL = object.latestCommentURL
        self.type = GithubNotificationType(rawValue: object.type) ?? GithubNotificationType.Issue
        
        if let repo = object.repository {
            self.repository = GithubRepoModel(object: repo)
        } else {
            return nil
        }
    }
}
