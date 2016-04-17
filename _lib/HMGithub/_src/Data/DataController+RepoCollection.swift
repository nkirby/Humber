// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

extension DataController {
    internal func currentRepoCollection() -> GithubRepoCollection? {
        return self.realm().objects(GithubRepoCollection.self).filter("userID = %@", self.userID).first
    }
    
    internal func newCurrentRepoCollection(write write: Bool = true) -> GithubRepoCollection {
        let collection = GithubRepoCollection()
        collection.userID = self.userID

        let block = {
            self.realm().add(collection)
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
        
        return collection
    }
}

// =======================================================

public protocol GithubAccountRepoDataFetchProviding {
    func currentAccountRepos() -> [GithubRepoModel]
    func currentAccountPublicRepos() -> [GithubRepoModel]
    func currentAccountOwnedPublicRepos() -> [GithubRepoModel]
    func currentAccountOwnedPrivateRepos() -> [GithubRepoModel]
    func currentAccountPrivateRepos() -> [GithubRepoModel]
    func currentAccountContributedPublicRepos() -> [GithubRepoModel]
    func currentAccountContributedPrivateRepos() -> [GithubRepoModel]
}

// =======================================================

extension DataController: GithubAccountRepoDataFetchProviding {
    public func currentAccountRepos() -> [GithubRepoModel] {
        return self.currentAccountPublicRepos() + self.currentAccountPrivateRepos()
    }
    
    public func currentAccountPublicRepos() -> [GithubRepoModel] {
        return self.currentRepoCollection()?.publicRepos.map { return GithubRepoModel(object: $0) } ?? []
    }
    
    public func currentAccountOwnedPublicRepos() -> [GithubRepoModel] {
        return self.currentRepoCollection()?.publicRepos.filter("owner.userID == %@", self.userID).map { GithubRepoModel(object: $0) } ?? []
    }
    
    public func currentAccountOwnedPrivateRepos() -> [GithubRepoModel] {
        return self.currentRepoCollection()?.privateRepos.filter("owner.userID == %@", self.userID).map { GithubRepoModel(object: $0) } ?? []
    }

    public func currentAccountPrivateRepos() -> [GithubRepoModel] {
        return self.currentRepoCollection()?.privateRepos.map { return GithubRepoModel(object: $0) } ?? []
    }

    public func currentAccountContributedPublicRepos() -> [GithubRepoModel] {
        return self.currentRepoCollection()?.publicRepos.filter("owner.userID != %@", self.userID).map { GithubRepoModel(object: $0) } ?? []
    }
    
    public func currentAccountContributedPrivateRepos() -> [GithubRepoModel] {
        return self.currentRepoCollection()?.privateRepos.filter("owner.userID != %@", self.userID).map { GithubRepoModel(object: $0) } ?? []
    }
}

// =======================================================

public protocol GithubAccountRepoDataSaveProviding {
    func saveAccountRepos(repoResponses responses: [GithubRepoResponse], type: GithubRepoType, write: Bool)
}

extension DataController: GithubAccountRepoDataSaveProviding {
    public func saveAccountRepos(repoResponses responses: [GithubRepoResponse], type: GithubRepoType, write: Bool) {
        let block = {
            let repoCollection: GithubRepoCollection
            if let obj = self.currentRepoCollection() {
                repoCollection = obj
            } else {
                repoCollection = self.newCurrentRepoCollection(write: false)
            }
            
            let publicRepos = repoCollection.publicRepos
            let privateRepos = repoCollection.privateRepos

            switch type {
            case .All:
                publicRepos.removeAll()
                privateRepos.removeAll()
                
            case .Public:
                publicRepos.removeAll()
                
            case .Private:
                privateRepos.removeAll()
            }
            
            for response in responses {
                self.saveRepo(repoResponse: response, write: false)
                
                if let repo = self.repoObj(repoID: response.repoID) {
                    if repo.repoPrivate {
                        privateRepos.append(repo)
                    } else {
                        publicRepos.append(repo)
                    }
                }
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
}


