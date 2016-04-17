// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

public enum GithubNotificationReason: String {
    case Subscribed = "subscribed"
    case Manual = "manual"
    case Author = "author"
    case Comment = "comment"
    case Mention = "mention"
    case TeamMention = "team_mention"
    case StateChange = "state_change"
    case Assign = "assign"
}

public enum GithubNotificationType: String {
    case Issue = "issue"
    case Commit = "commit"
    case PullRequest = "pullrequest"
    
    public func image() -> Image {
        switch self {
        case .Issue:
            return Image(source: .Local("issues"), type: .PNG)
            
        case .Commit:
            return Image(source: .Local("commit"), type: .PNG)
            
        case .PullRequest:
            return Image(source: .Local("prs"), type: .PNG)
        }
    }
}
