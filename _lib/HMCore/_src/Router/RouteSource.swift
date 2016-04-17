// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

public struct RouteSource: OptionSetType {
    public let rawValue: UInt
    
    public static let UserInitiated = RouteSource(rawValue: 0)
    public static let AppInitiated = RouteSource(rawValue: 1)
    public static let LaunchTarget = RouteSource(rawValue: 1 << 1)
    
    public static var All: RouteSource {
        return [.UserInitiated, .AppInitiated, .LaunchTarget]
    }
    
    public static var NotLaunched: RouteSource {
        return [.UserInitiated, .AppInitiated]
    }
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}
