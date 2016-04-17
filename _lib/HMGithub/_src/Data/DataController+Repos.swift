// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

public protocol GithubRepoDataProviding {
    func repo(repoID repoID: String) -> GithubRepoModel?
    func repo(repoName repoName: String, repoOwner: String) -> GithubRepoModel?
    func saveRepo(repoResponse response: GithubRepoResponse, write: Bool)
    func saveRepos(repoResponses responses: [GithubRepoResponse], write: Bool)
}

extension DataController: GithubRepoDataProviding {
    internal func repoObj(repoID repoID: String) -> GithubRepo? {
        return self.realm().objects(GithubRepo.self).filter("repoID == %@", repoID).first
    }
    
    public func repo(repoID repoID: String) -> GithubRepoModel? {
        if let repo = self.repoObj(repoID: repoID) {
            return GithubRepoModel(object: repo)
        }
        
        return nil
    }
    
    internal func repoObj(repoName repoName: String, repoOwner: String) -> GithubRepo? {
        return self.realm().objects(GithubRepo.self).filter("name == %@ AND owner.login == %@", repoName, repoOwner).first
    }
    
    public func repo(repoName repoName: String, repoOwner: String) -> GithubRepoModel? {
        if let obj = self.repoObj(repoName: repoName, repoOwner: repoOwner) {
            return GithubRepoModel(object: obj)
        }
        
        return nil
    }
    
    public func saveRepo(repoResponse response: GithubRepoResponse, write: Bool = true) {
        let block = {
            let repo: GithubRepo
            if let obj = self.repoObj(repoID: response.repoID) {
                repo = obj
            } else {
                repo = GithubRepo()
                repo.repoID = response.repoID
                self.realm().add(repo)
            }
            
            repo.name = response.name
            repo.fullName = response.fullName
            repo.repoPrivate = response.repoPrivate
            repo.htmlURL = response.htmlURL
            repo.repoDescription = response.repoDescription
            repo.fork = response.fork
            repo.gitURL = response.gitURL
            repo.sshURL = response.sshURL
            repo.svnURL = response.svnURL
            repo.homepage = response.homepage
            repo.size = response.size
            repo.stargazersCount = response.stargazersCount
            repo.language = response.language
            repo.hasIssues = response.hasIssues
            repo.hasDownloads = response.hasDownloads
            repo.hasWiki = response.hasWiki
            repo.hasPages = response.hasPages
            repo.forksCount = response.forksCount
            repo.openIssuesCount = response.openIssuesCount
            repo.forks = response.forks
            repo.openIssues = response.openIssues
            repo.watchers = response.watchers
            repo.defaultBranch = response.defaultBranch
            repo.permissionsAdmin = response.permissionsAdmin
            repo.permissionsPush = response.permissionsPush
            repo.permissionsPull = response.permissionsPush
            
            if let ownerResponse = response.owner {
                self.saveUser(response: ownerResponse, write: false)
                
                if let owner = self.userObj(userID: ownerResponse.userID) {
                    repo.owner = owner
                }
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
    
    public func saveRepos(repoResponses responses: [GithubRepoResponse], write: Bool) {
        let block = {
            for response in responses {
                self.saveRepo(repoResponse: response, write: false)
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
}
