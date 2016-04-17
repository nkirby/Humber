// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public struct GithubOverviewItemModel {
    public let itemID: String
    
    public let sortOrder: Int
    public let type: String
    public let title: String
    public let value: Int
    public let query: String
    public let repoName: String
    public let repoOwner: String
    public let action: String
    public let threshold: Int
    
    public init(object: GithubOverviewItem) {
        self.itemID = object.itemID
        self.sortOrder = object.sortOrder
        self.type = object.type
        self.title = object.title
        self.value = object.value
        self.query = object.query
        self.repoName = object.repoName
        self.repoOwner = object.repoOwner
        self.action = object.action
        self.threshold = object.threshold
    }
}
