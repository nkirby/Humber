// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

// =======================================================

class AccountFollowersViewController: UITableViewController, PullToRefreshProviding {
    internal var username: String?
    private var users = [GithubUserModel]()

// =======================================================
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItem()
        self.setupTableView()
        self.setupPullToRefresh(self, action: #selector(AccountFollowersViewController.sync))

        self.fetch()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sync()
    }
    
// =======================================================
// MARK: - Setup
    
    private func setupNavigationItem() {
        self.navigationItem.title = "Followers"
    }
    
    private func setupTableView() {
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
    }
    
// =======================================================
// MARK: - Data Lifecycle
    
    private func fetch() {
        Async.main {
            self.refreshControl?.endRefreshing()
            
            if let users = ServiceController.component(GithubAccountFollowersDataProviding.self)?.currentAccountFollowers() {
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func sync() {
        if let username = self.username {
            ServiceController.component(GithubAccountFollowersSyncProviding.self)?.syncAccountFollowers(username: username).startWithNext { self.fetch() }
        } else {
            ServiceController.component(GithubAccountFollowersSyncProviding.self)?.syncCurrentAccountFollowers().startWithNext { self.fetch() }
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
