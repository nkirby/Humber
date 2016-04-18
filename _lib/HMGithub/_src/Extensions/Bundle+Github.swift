// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

class GithubBundle {}

extension Bundle {
    public func githubBundle() -> NSBundle {
        return NSBundle(forClass: GithubBundle.self)
    }
}
