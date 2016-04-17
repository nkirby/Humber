// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

import HMCore

// =======================================================

public protocol GithubAccountFollowingDataProviding {
    func currentAccountFollowing() -> [GithubUserModel]
    func saveAccountFollowing(userResponses responses: [GithubUserResponse], write: Bool)
}

extension DataController: GithubAccountFollowingDataProviding {
    internal func currentAccountObjFollowing() -> List<GithubUser>? {
        return self.currentAccountObj?.followingUsers
    }
    
    public func currentAccountFollowing() -> [GithubUserModel] {
        return self.currentAccountObjFollowing()?.map { return GithubUserModel(object: $0) } ?? []
    }
    
    public func saveAccountFollowing(userResponses responses: [GithubUserResponse], write: Bool = true) {
        let block = {
            guard let following = self.currentAccountObjFollowing() else {
                return
            }
            
            following.removeAll()
            
            for response in responses {
                self.saveUser(response: response, write: false)
                
                if let user = self.userObj(userID: response.userID) {
                    following.append(user)
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
