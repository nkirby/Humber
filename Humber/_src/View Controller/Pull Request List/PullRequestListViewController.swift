// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async
import SafariServices

import HMCore
import HMGithub

// =======================================================

class PullRequestListViewController: UITableViewController, NavigationBarUpdating, TableDividerUpdating {

// =======================================================
// MARK: - Init, etc...
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.navigationController?.tabBarItem.imageInsets = UIEdgeInsets(top: 4.0, left: 0.0, bottom: -4.0, right: 0.0)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
// =======================================================
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItemTitle()
        self.setupNavigationBarStyling()
        self.setupTableView()
        self.updateTableDivider()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PullRequestListViewController.didChangeTheme), name: Theme.themeChangedNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// =======================================================
// MARK: - Setup
    
    private func setupNavigationItemTitle() {
        self.navigationItem.title = "Pull Requests"
    }
    
    private func setupTableView() {
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
    }
    
    @objc private func didChangeTheme() {
        self.updateTableDivider()
        self.setupTableView()
        self.setupNavigationBarStyling()
    }

// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
