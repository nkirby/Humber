// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

internal protocol SelectItemActionDelegate: class {
    func didSelectAction(action action: GithubOverviewItemAction)
}

// =======================================================

class SelectItemTypeViewController: UITableViewController, TableDividerUpdating {
    internal weak var delegate: SelectItemActionDelegate?
    private let items: [GithubOverviewItemAction] = [.Issues, .Notifications, .PullRequests]

// =======================================================
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupNavigationItemTitle()
        self.updateTableDivider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// =======================================================
// MARK: - Setup
    
    private func setupTableView() {
//        self.tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
        
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setupNavigationItemTitle() {
        self.navigationItem.title = "Type"
    }

// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "repoCell")
        
        if let item = self.items.get(indexPath.row) {
            cell.textLabel?.attributedText = NSAttributedString(string: item.rawValue.capitalizedString, attributes: [
                NSFontAttributeName: Theme.font(type: .Bold(14.0)),
                NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor)
            ])
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let item = self.items.get(indexPath.row) else {
            return
        }
        
        self.delegate?.didSelectAction(action: item)
    }
}
