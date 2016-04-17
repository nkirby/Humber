// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import Janus

import HMCore

// =======================================================

public struct GithubRepoResponse: JSONDecodable {
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
    
    // createdAt
    // updatedAt
    // pushedAt
    
    public let owner: GithubUserResponse?
    
// =======================================================
// MARK: - Init, etc...
    
    public init?(json: JSONValue<JSONDictionary>) {
        if let repoID = json["id"].to(String.self) {
            self.repoID = repoID
        } else if let repoID = json["id"].to(Int.self) {
            self.repoID = "\(repoID)"
        } else {
            return nil
        }
    
        self.name = json["name"].stringValue(defaultValue: "")
        self.fullName = json["full_name"].stringValue(defaultValue: "")
        self.repoPrivate = json["private"].boolValue(defaultValue: false)
        self.htmlURL = json["html_url"].stringValue(defaultValue: "")
        self.repoDescription = json["description"].stringValue(defaultValue: "")
        self.fork = json["fork"].boolValue(defaultValue: false)
        self.gitURL = json["git_url"].stringValue(defaultValue: "")
        self.sshURL = json["ssh_url"].stringValue(defaultValue: "")
        self.svnURL = json["svn_url"].stringValue(defaultValue: "")
        self.homepage = json["homepage"].stringValue(defaultValue: "")
        self.size = json["size"].intValue(defaultValue: 0)
        self.stargazersCount = json["stargazers_count"].intValue(defaultValue: 0)
        self.language = json["language"].stringValue(defaultValue: "")
        self.hasIssues = json["has_issues"].boolValue(defaultValue: false)
        self.hasDownloads = json["has_downloads"].boolValue(defaultValue: false)
        self.hasWiki = json["has_wiki"].boolValue(defaultValue: false)
        self.hasPages = json["has_pages"].boolValue(defaultValue: false)
        self.forksCount = json["forks_count"].intValue(defaultValue: 0)
        self.openIssuesCount = json["open_issues_count"].intValue(defaultValue: 0)
        self.forks = json["forks"].intValue(defaultValue: 0)
        self.openIssues = json["open_issues"].intValue(defaultValue: 0)
        self.watchers = json["watchers"].intValue(defaultValue: 0)
        self.defaultBranch = json["default_branch"].stringValue(defaultValue: "")
        self.permissionsAdmin = json["permissions"]["admin"].boolValue(defaultValue: false)
        self.permissionsPull = json["permissions"]["pull"].boolValue(defaultValue: false)
        self.permissionsPush = json["permissions"]["push"].boolValue(defaultValue: false)
        
        if let ownerDict = json["owner"].jsonDictionaryValue() {
            self.owner = JSONParser.model(GithubUserResponse.self).from(ownerDict)
        } else {
            self.owner = nil
        }
    }
}
