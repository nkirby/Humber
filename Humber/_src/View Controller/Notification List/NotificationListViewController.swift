// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

// =======================================================

class NotificationListViewController: UITableViewController, NavigationBarUpdating, PullToRefreshProviding, UIViewControllerPreviewingDelegate {
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
        
        if self.traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
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
    
// =======================================================
// MARK: - Force Touch
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location),
            let notification = self.notifications.get(indexPath.row),
            let vc = UIStoryboard(name: "Repos", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("repoViewController") as? RepoViewController else {
                return nil
        }

        vc.repoName = notification.repository.name
        vc.repoOwner = notification.repository.owner?.login
        return vc
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
