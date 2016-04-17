// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

public protocol PullToRefreshProviding: class {
    var refreshControl: UIRefreshControl? { get set }
}

public extension PullToRefreshProviding {
    public func setupPullToRefresh(target: AnyObject, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl
    }
}
