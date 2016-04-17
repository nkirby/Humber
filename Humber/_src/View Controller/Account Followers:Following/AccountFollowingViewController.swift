// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

// =======================================================

class AccountFollowingViewController: UITableViewController, PullToRefreshProviding, TableDividerUpdating {
    internal var username: String?
    private var users = [GithubUserModel]()

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
// =======================================================
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItem()
        self.setupTableView()
        self.setupPullToRefresh(self, action: #selector(AccountFollowingViewController.sync))
        self.updateTableDivider()
        
        self.fetch()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AccountFollowingViewController.didChangeTheme), name: Theme.themeChangedNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sync()
    }
    
// =======================================================
// MARK: - Setup
    
    private func setupNavigationItem() {
        self.navigationItem.title = "Following"
    }
    
    private func setupTableView() {
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
    }
    
    @objc private func didChangeTheme() {
        self.updateTableDivider()
        self.setupTableView()
    }

// =======================================================
// MARK: - Data Lifecycle
    
    private func fetch() {
        Async.main {
            self.refreshControl?.endRefreshing()

            if let users = ServiceController.component(GithubAccountFollowingDataProviding.self)?.currentAccountFollowing() {
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func sync() {
        if let username = self.username {
            ServiceController.component(GithubAccountFollowingSyncProviding.self)?.syncAccountFollowing(username: username).startWithNext { self.fetch() }
        } else {
            ServiceController.component(GithubAccountFollowingSyncProviding.self)?.syncCurrentAccountFollowing().startWithNext { self.fetch() }
        }
    }
    
// =======================================================
// MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let user = self.users.get(indexPath.row),
            let cell = tableView.dequeueReusableCellWithIdentifier("AccountFollowedUserCell") as? AccountFollowedUserCell else {
                return UITableViewCell()
        }
        
        cell.render(model: user)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
