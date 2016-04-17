// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

import HMCore

// =======================================================

public protocol GithubAccountFollowersDataProviding {
    func currentAccountFollowers() -> [GithubUserModel]
    func saveAccountFollowers(userResponses responses: [GithubUserResponse], write: Bool)
}

extension DataController: GithubAccountFollowersDataProviding {
    internal func currentAccountObjFollowers() -> List<GithubUser>? {
        return self.currentAccountObj?.followerUsers
    }
    
    public func currentAccountFollowers() -> [GithubUserModel] {
        return self.currentAccountObjFollowers()?.map { return GithubUserModel(object: $0) } ?? []
    }
    
    public func saveAccountFollowers(userResponses responses: [GithubUserResponse], write: Bool = true) {
        let block = {
            guard let followers = self.currentAccountObjFollowers() else {
                return
            }
            
            followers.removeAll()
            
            for response in responses {
                self.saveUser(response: response, write: false)
                
                if let user = self.userObj(userID: response.userID) {
                    followers.append(user)
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
