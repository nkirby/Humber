// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

public class GithubOverviewItemThreshold: NSObject {
    public static func stringValue(threshold threshold: Int) -> String {
        if threshold < 0 {
            return "None"
        } else {
            return "\(threshold)"
        }
    }
}
