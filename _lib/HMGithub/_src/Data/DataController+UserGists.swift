// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

import HMCore

// =======================================================

public protocol GithubAccountGistDataProviding {
    func currentAccountGists() -> [GithubGistModel]
    func saveAccountGists(gistResponses responses: [GithubGistResponse], write: Bool)
}

extension DataController: GithubAccountGistDataProviding {
    internal func currentAccountObjGists() -> List<GithubGist>? {
        return self.currentAccountObj?.gists
    }
    
    public func currentAccountGists() -> [GithubGistModel] {
        return self.currentAccountObjGists()?.flatMap { GithubGistModel(object: $0) } ?? []
    }
    
    public func saveAccountGists(gistResponses responses: [GithubGistResponse], write: Bool) {
        let block = {
            guard let gists = self.currentAccountObjGists() else {
                return
            }
            
            gists.removeAll()
            
            for response in responses {
                self.saveGist(gistResponse: response, write: false)
                
                if let gist = self.gistObj(gistID: response.gistID) {
                    gists.append(gist)
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