// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

public protocol GithubGistDataProviding {
    func gist(gistID gistID: String) -> GithubGistModel?
    func saveGist(gistResponse response: GithubGistResponse, write: Bool)
    func saveGists(gistResponses responses: [GithubGistResponse], write: Bool)
}

extension DataController: GithubGistDataProviding {
    internal func gistObj(gistID gistID: String) -> GithubGist? {
        return self.realm().objects(GithubGist.self).filter("gistID = %@", gistID).first
    }
    
    public func gist(gistID gistID: String) -> GithubGistModel? {
        if let gist = self.gistObj(gistID: gistID) {
            return GithubGistModel(object: gist)
        }
        
        return nil
    }
    
    public func saveGist(gistResponse response: GithubGistResponse, write: Bool) {
        let block = {
            let gist: GithubGist
            if let obj = self.gistObj(gistID: response.gistID) {
                gist = obj
            } else {
                gist = GithubGist()
                gist.gistID = response.gistID
                self.realm().add(gist, update: true)
            }
            
            gist.url = response.url
            gist.htmlURL = response.htmlURL
            gist.gistPublic = response.gistPublic
            gist.gistDescription = response.gistDescription
            gist.comments = response.comments
            gist.commentsURL = response.commentsURL
            gist.truncated = response.truncated
            
            self.saveUser(response: response.owner, write: false)
            if let user = self.userObj(userID: response.owner.userID) {
                gist.owner = user
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
    
    public func saveGists(gistResponses responses: [GithubGistResponse], write: Bool) {
        let block = {
            for response in responses {
                self.saveGist(gistResponse: response, write: false)
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
}
