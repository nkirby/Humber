// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

import HMCore

// =======================================================

public protocol GithubNotificationDataProviding {
    func currentAccountNotifications() -> [GithubNotificationModel]
    func notification(notificationID notificationID: String) -> GithubNotificationModel?
    func saveAccountNotifications(notificationResponses responses: [GithubNotificationResponse], write: Bool)
}

extension DataController: GithubNotificationDataProviding {
    internal func currentAccountObjNotifications(write write: Bool = true) -> List<GithubNotification> {
        if let coll = self.currentNotificationCollection() {
            return coll.notifications
        }
        
        return self.newNotificationCollection(write: write).notifications
    }
    
    public func currentAccountNotifications() -> [GithubNotificationModel] {
        return self.currentAccountObjNotifications().flatMap { GithubNotificationModel(object: $0) } ?? []
    }
    
    internal func notificationObj(notificationID notificationID: String) -> GithubNotification? {
        return self.realm().objects(GithubNotification.self).filter("notificationID == %@", notificationID).first
    }
    
    public func notification(notificationID notificationID: String) -> GithubNotificationModel? {
        if let obj = self.notificationObj(notificationID: notificationID) {
            return GithubNotificationModel(object: obj)
        }
        
        return nil
    }
    
    public func saveAccountNotifications(notificationResponses responses: [GithubNotificationResponse], write: Bool) {
        let block = {
            for response in responses {
                let notif: GithubNotification
                if let obj = self.notificationObj(notificationID: response.notificationID) {
                    notif = obj
                } else {
                    notif = GithubNotification()
                    notif.notificationID = response.notificationID
                    self.realm().add(notif, update: true)
                }
                
                notif.unread = response.unread
                notif.reason = response.reason.rawValue
                notif.title = response.title
                notif.subjectURL = response.subjectURL
                notif.latestCommentURL = response.latestCommentURL
                notif.type = response.type.rawValue
                
                self.saveRepo(repoResponse: response.repository, write: false)
                if let repo = self.repoObj(repoID: response.repository.repoID) {
                    notif.repository = repo
                }
                
                self.currentAccountObjNotifications(write: false).append(notif)
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
}
