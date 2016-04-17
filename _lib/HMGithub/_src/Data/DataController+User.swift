// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

import HMCore

// =======================================================

public protocol GithubUserDataProviding {
    func user(userID userID: String) -> GithubUserModel?
    func saveUser(response response: GithubUserResponse, write: Bool)
    func saveUsers(userResponses responses: [GithubUserResponse], write: Bool)
}

// =======================================================

extension DataController: GithubUserDataProviding {
    internal func userObj(userID userID: String) -> GithubUser? {
        let realm = self.realm()
        return realm.objects(GithubUser.self).filter("userID = %@", userID).first
    }
    
    public func user(userID userID: String) -> GithubUserModel? {
        if let obj = self.userObj(userID: userID) {
            return GithubUserModel(object: obj)
        }
        
        return nil
    }
    
    public func saveUser(response response: GithubUserResponse, write: Bool = true) {
        let block = {
            let user: GithubUser
            if let obj = self.userObj(userID: response.userID) {
                user = obj
            } else {
                user = GithubUser()
                user.userID = response.userID
                self.realm().add(user)
            }
            
            user.login = response.login
            user.url = response.url
            user.type = response.type
            user.siteAdmin = response.siteAdmin
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
    
    public func saveUsers(userResponses responses: [GithubUserResponse], write: Bool = true) {
        let block = {
            for response in responses {
                self.saveUser(response: response, write: false)
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
}

