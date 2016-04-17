// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public struct GithubRepoModel {
    public let repoID: String
    public let name: String
    public let fullName: String
    public let repoPrivate: Bool
    public let htmlURL: String
    public let repoDescription: String
    public let fork: Bool
    public let gitURL: String
    public let sshURL: String
    public let svnURL: String
    public let homepage: String
    public let size: Int
    public let stargazersCount: Int
    public let language: String
    public let hasIssues: Bool
    public let hasDownloads: Bool
    public let hasWiki: Bool
    public let hasPages: Bool
    public let forksCount: Int
    public let openIssuesCount: Int
    public let forks: Int
    public let openIssues: Int
    public let watchers: Int
    public let defaultBranch: String
    public let permissionsAdmin: Bool
    public let permissionsPush: Bool
    public let permissionsPull: Bool

    public let owner: GithubUserModel?
    
// =======================================================
// MARK: - Response -> Model
    
    public init(response: GithubRepoResponse) {
        self.repoID = response.repoID
        self.name = response.name
        self.fullName = response.fullName
        self.repoPrivate = response.repoPrivate
        self.htmlURL = response.htmlURL
        self.repoDescription = response.repoDescription
        self.fork = response.fork
        self.gitURL = response.gitURL
        self.sshURL = response.sshURL
        self.svnURL = response.svnURL
        self.homepage = response.homepage
        self.size = response.size
        self.stargazersCount = response.stargazersCount
        self.language = response.language
        self.hasIssues = response.hasIssues
        self.hasDownloads = response.hasDownloads
        self.hasWiki = response.hasWiki
        self.hasPages = response.hasPages
        self.forksCount = response.forksCount
        self.openIssuesCount = response.openIssuesCount
        self.forks = response.forks
        self.openIssues = response.openIssues
        self.watchers = response.watchers
        self.defaultBranch = response.defaultBranch
        self.permissionsAdmin = response.permissionsAdmin
        self.permissionsPush = response.permissionsPush
        self.permissionsPull = response.permissionsPull
        
        if let owner = response.owner {
            self.owner = GithubUserModel(response: owner)
        } else {
            self.owner = nil
        }
    }
    
// =======================================================
// MARK: - Object -> Model
    
    public init(object: GithubRepo) {
        self.repoID = object.repoID
        self.name = object.name
        self.fullName = object.fullName
        self.repoPrivate = object.repoPrivate
        self.htmlURL = object.htmlURL
        self.repoDescription = object.repoDescription
        self.fork = object.fork
        self.gitURL = object.gitURL
        self.sshURL = object.sshURL
        self.svnURL = object.svnURL
        self.homepage = object.homepage
        self.size = object.size
        self.stargazersCount = object.stargazersCount
        self.language = object.language
        self.hasIssues = object.hasIssues
        self.hasDownloads = object.hasDownloads
        self.hasWiki = object.hasWiki
        self.hasPages = object.hasPages
        self.forksCount = object.forksCount
        self.openIssuesCount = object.openIssuesCount
        self.forks = object.forks
        self.openIssues = object.openIssues
        self.watchers = object.watchers
        self.defaultBranch = object.defaultBranch
        self.permissionsAdmin = object.permissionsAdmin
        self.permissionsPush = object.permissionsPush
        self.permissionsPull = object.permissionsPull
        
        if let owner = object.owner {
            self.owner = GithubUserModel(object: owner)
        } else {
            self.owner = nil
        }
    }
}
