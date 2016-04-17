// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

public protocol RealmFilePathProviding {
    var realmFilePath: String { get }
    var realmContainerPath: String { get }
}

public class DataController: NSObject, RealmFilePathProviding {
    private(set) public var realmFilePath: String
    private(set) public var realmContainerPath: String
    private let configuration: Realm.Configuration
    public let userID: String
    
    public init(context: ServiceContext, realmIdentifier: String) {
        self.userID = context.userIdentifier
        
        let fileManager = FileManager(fileStorageContainer: .Documents, realmPrefix: "realm")
        let path = fileManager.realm(realmIdentifier: realmIdentifier)
        self.realmFilePath = path.path!
        self.realmContainerPath = fileManager.realmFolder(realmIdentifier: realmIdentifier).path!
        
        self.configuration = Realm.Configuration(path: path.path, migrationBlock: { migration, oldSchemaVersion in
        })
        
        super.init()
    }
    
    private func inMemoryRealm() -> Realm {
        return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "realm"))
    }
    
    public func realm() -> Realm {
        do {
            return try Realm(configuration: self.configuration)
        } catch {
            return self.inMemoryRealm()
        }
    }
    
    public func withRealmTransaction(@noescape block: ((Void) -> Void)) {
        let realm = self.realm()
        realm.beginWrite()
        block()
        try! realm.commitWrite()
    }
}
