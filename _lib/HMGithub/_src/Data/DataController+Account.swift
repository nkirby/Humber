// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

public protocol GithubAccountDataProviding {
    var currentAccount: GithubAccountModel? { get }
    func account(userID userID: String) -> GithubAccountModel?
    func saveCurrentUser(accountResponse response: GithubAccountResponse, write: Bool)
}

// =======================================================

extension DataController: GithubAccountDataProviding {
    
// =======================================================
// MARK: - Private Accessors
    
    internal var currentAccountObj: GithubAccount? {
        return self.accountObj(userID: self.userID)
    }
    
    internal func accountObj(userID userID: String) -> GithubAccount? {
        let realm = self.realm()
        return realm.objects(GithubAccount.self).filter("userID = %@", userID).first
    }

// =======================================================
// MARK: - Account
    
    public var currentAccount: GithubAccountModel? {
        return self.account(userID: self.userID)
    }
    
    public func account(userID userID: String) -> GithubAccountModel? {
        if let obj = self.accountObj(userID: userID) {
            return GithubAccountModel(object: obj)
        }
        
        return nil
    }
    
    public func saveCurrentUser(accountResponse response: GithubAccountResponse, write: Bool = true) {
        let realm = self.realm()
        
        let block = {
            let account: GithubAccount
            if let currentAccount = self.currentAccountObj {
                account = currentAccount
            } else {
                account = GithubAccount()
                account.userID = self.userID
                realm.add(account, update: true)
            }
            
            account.avatarURL = response.avatarURL
            account.bio = response.bio
            account.blog = response.blog
            account.collaborators = response.collaborators
            account.company = response.company
            account.email = response.email
            account.followers = response.followers
            account.following = response.following
            account.hireable = response.hireable
            account.htmlURL = response.htmlURL
            account.location = response.location
            account.login = response.login
            account.name = response.name
            account.ownedPrivateRepos = response.ownedPrivateRepos
            account.privateGists = response.privateGists
            account.publicGists = response.publicGists
            account.publicRepos = response.publicRepos
            account.siteAdmin = response.siteAdmin
            account.totalPrivateRepos = response.totalPrivateRepos
            account.type = response.type
            account.url = response.url
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
}
