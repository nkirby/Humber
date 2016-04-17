// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

public struct GithubAccountModel {
    public let avatarURL: String
    public let bio: String
    public let blog: String
    public let collaborators: Int
    public let company: String
//    public let createdAt: String
    public let email: String
    public let followers: Int
    public let following: Int
    public let hireable: Bool
    public let htmlURL: String
    public let userID: String
    public let location: String
    public let login: String
    public let name: String
    public let ownedPrivateRepos: Int
    public let privateGists: Int
    public let publicGists: Int
    public let publicRepos: Int
    public let siteAdmin: Int
    public let totalPrivateRepos: Int
    public let type: String
//    public let updatedAt: String
    public let url: String
    
// =======================================================
// MARK: - Response -> Model
    
    public init(response: GithubAccountResponse) {
        self.avatarURL = response.avatarURL
        self.bio = response.bio
        self.blog = response.blog
        self.collaborators = response.collaborators
        self.company = response.company
        self.email = response.email
        self.followers = response.followers
        self.following = response.following
        self.hireable = response.hireable
        self.htmlURL = response.htmlURL
        self.userID = response.userID
        self.location = response.location
        self.login = response.login
        self.name = response.name
        self.ownedPrivateRepos = response.ownedPrivateRepos
        self.privateGists = response.privateGists
        self.publicGists = response.publicGists
        self.publicRepos = response.publicRepos
        self.siteAdmin = response.siteAdmin
        self.totalPrivateRepos = response.totalPrivateRepos
        self.type = response.type
        self.url = response.url
    }
    
    public init(object: GithubAccount) {
        self.avatarURL = object.avatarURL
        self.bio = object.bio
        self.blog = object.blog
        self.collaborators = object.collaborators
        self.company = object.company
        self.email = object.email
        self.followers = object.followers
        self.following = object.following
        self.hireable = object.hireable
        self.htmlURL = object.htmlURL
        self.userID = object.userID
        self.location = object.location
        self.login = object.login
        self.name = object.name
        self.ownedPrivateRepos = object.ownedPrivateRepos
        self.privateGists = object.privateGists
        self.publicGists = object.publicGists
        self.publicRepos = object.publicRepos
        self.siteAdmin = object.siteAdmin
        self.totalPrivateRepos = object.totalPrivateRepos
        self.type = object.type
        self.url = object.url
    }
}
