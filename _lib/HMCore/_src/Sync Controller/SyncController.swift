// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa

public enum SyncError: ErrorType {
    case UnableToSync
    case MissingNetworkConnection
    case Unknown
}

// =======================================================

public class SyncController: NSObject {
    public let userID: String
    
    public init(context: ServiceContext) {
        self.userID = context.userIdentifier
        
        super.init()
    }
}
