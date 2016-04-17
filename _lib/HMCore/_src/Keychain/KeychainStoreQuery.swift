// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

public protocol KeychainStoreQuery {
    var serviceKey: String { get }
    var useAccessGroup: Bool { get }
}
