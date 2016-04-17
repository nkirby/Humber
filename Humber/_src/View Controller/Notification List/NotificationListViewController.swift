// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

// =======================================================

class NotificationListViewController: UITableViewController, NavigationBarUpdating, PullToRefreshProviding {
    private var notifications = [GithubNotificationModel]()

// =======================================================
// MARK: - Init, etc...
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.navigationController?.tabBarItem.imageInsets = UIEdgeInsets(top: 4.0, left: 0.0, bottom: -4.0, right: 0.0)
    }

// =======================================================
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationItemTitle()
        self.setupNavigationBarStyling()
        self.setupTableView()
        self.setupPullToRefresh(self, action: #selector(NotificationListViewController.sync))
        
        self.fetch()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sync()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// =======================================================
// MARK: - Setup
    
    private func setupNavigationItemTitle() {
        self.navigationItem.title = "Notifications"
    }
    
    private func setupTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
    }
    
// =======================================================
// MARK: - Data Lifecycle
    
    private func fetch() {
        Async.main {
            self.refreshControl?.endRefreshing()
            
            guard let notifs = ServiceController.component(GithubNotificationDataProviding.self)?.currentAccountNotifications() else {
                return
            }
            
            self.notifications = notifs
            self.tableView.reloadData()
        }
    }
    
    @objc private func sync() {
        ServiceController.component(GithubNotificationsSyncProviding.self)?.syncAccountNotifications().startWithNext { self.fetch() }
    }
    
    
// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let notification = self.notifications.get(indexPath.row),
            let cell = tableView.dequeueReusableCellWithIdentifier("SingleNotificationCell") as? SingleNotificationCell else {
                return UITableViewCell()
        }
        
        cell.render(model: notification)
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let notif = self.notifications.get(indexPath.row),
            let owner = notif.repository.owner else {
                return
        }
        
        Router.route(path: GithubRoutes.singleRepo(username: owner.login, repoName: notif.repository.name), source: .UserInitiated)
    }
}
