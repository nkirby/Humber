// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore

// =======================================================

public protocol NavigationBarUpdating {
    var navigationController: UINavigationController? { get }
}

extension NavigationBarUpdating {
    public func setupNavigationBarStyling() {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor),
            NSFontAttributeName: Theme.font(type: .Bold(14.0))
        ]
    }
}
