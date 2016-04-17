// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

public struct GithubKeychainStoreQuery: KeychainStoreQuery {
    public let serviceKey: String = "github"
    public let useAccessGroup: Bool = false
}
