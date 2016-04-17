// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

public protocol TableDividerUpdating {
    var tableView: UITableView! { get }
}

public extension TableDividerUpdating {
    public func updateTableDivider() {
        self.tableView?.separatorColor = Theme.color(type: .DividerColor)
    }
}