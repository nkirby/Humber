// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

// =======================================================

class AccountViewController: UITableViewController, NavigationBarUpdating, PullToRefreshProviding, UIViewControllerPreviewingDelegate {
    private var user: GithubAccountModel?

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

        self.setupTableView()
        self.setupNavigationBarStyling()
        self.setupPullToRefresh(self, action: #selector(AccountViewController.sync))
        self.fetch()
        
        if self.traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sync()
    }
    
// =======================================================
// MARK: - Setup
    
    private func setupTableView() {
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
// =======================================================
// MARK: - Data Lifecycle
    
    private func fetch() {
        Async.main {
            self.refreshControl?.endRefreshing()

            self.user = ServiceController.component(GithubAccountDataProviding.self)?.currentAccount
            self.tableView.reloadData()
        }
    }
    
    @objc private func sync() {
        ServiceController.component(GithubAccountSyncProviding.self)?.syncCurrentGithubAccount().startWithNext { self.fetch() }
    }
    
// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.user != nil {
            return 3
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
            
        case 1:
            return 3
            
        case 2:
            return 1
            
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let user = self.user else {
            return UITableViewCell()
        }
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            if let cell = tableView.dequeueReusableCellWithIdentifier("AccountIconAndCountCell") as? AccountIconAndCountCell {
                let viewModel = AccountIconAndCountViewModel(title: "Followers", icon: Image(source: .Local("followers"), type: .PNG), count: user.followers)
                cell.render(model: viewModel)
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
            }
            
        case (0, 1):
            if let cell = tableView.dequeueReusableCellWithIdentifier("AccountIconAndCountCell") as? AccountIconAndCountCell {
                let viewModel = AccountIconAndCountViewModel(title: "Following", icon: Image(source: .Local("followers"), type: .PNG), count: user.following)
                cell.render(model: viewModel)
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
            }

        case (1, 0):
            if let cell = tableView.dequeueReusableCellWithIdentifier("AccountIconAndCountCell") as? AccountIconAndCountCell {
                let viewModel = AccountIconAndCountViewModel(title: "All Repos", icon: Image(source: .Local("followers"), type: .PNG), count: (user.publicRepos + user.ownedPrivateRepos))
                cell.render(model: viewModel)
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
            }

        case (1, 1):
            if let cell = tableView.dequeueReusableCellWithIdentifier("AccountIconAndCountCell") as? AccountIconAndCountCell {
                let viewModel = AccountIconAndCountViewModel(title: "Public Repos", icon: Image(source: .Local("followers"), type: .PNG), count: user.publicRepos)
                cell.render(model: viewModel)
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
            }

        case (1, 2):
            if let cell = tableView.dequeueReusableCellWithIdentifier("AccountIconAndCountCell") as? AccountIconAndCountCell {
                let viewModel = AccountIconAndCountViewModel(title: "Private Repos", icon: Image(source: .Local("followers"), type: .PNG), count: user.ownedPrivateRepos)
                cell.render(model: viewModel)
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
            }

        case (2, 0):
            if let cell = tableView.dequeueReusableCellWithIdentifier("AccountIconAndCountCell") as? AccountIconAndCountCell {
                let viewModel = AccountIconAndCountViewModel(title: "Public Gists", icon: Image(source: .Local("followers"), type: .PNG), count: user.publicGists)
                cell.render(model: viewModel)
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                return cell
            }
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let user = self.user else {
            return
        }
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            Router.route(path: GithubRoutes.followers(username: user.login), source: .UserInitiated)
            
        case (0, 1):
            Router.route(path: GithubRoutes.following(userID: user.userID), source: .UserInitiated)
            
        case (1, 0):
            Router.route(path: GithubRoutes.repos(userID: user.userID, type: "all"), source: .UserInitiated)
            
        case (1, 1):
            Router.route(path: GithubRoutes.repos(userID: user.userID, type: "public"), source: .UserInitiated)
            
        case (1, 2):
            Router.route(path: GithubRoutes.repos(userID: user.userID, type: "private"), source: .UserInitiated)
            
        case (2, 0):
            Router.route(path: GithubRoutes.gists(userID: user.userID, type: "public"), source: .UserInitiated)
                        
        default:
            break
        }
    }
    
// =======================================================
// MARK: - Force Touch
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location),
            let user = self.user else {
                return nil
        }
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            if let vc = UIStoryboard(name: "Account", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("accountFollowersViewController") as? AccountFollowersViewController  {
                vc.username = user.login
                return vc
            }
            
        case (0, 1):
            if let vc = UIStoryboard(name: "Account", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("accountFollowingViewController") as? AccountFollowingViewController  {
                vc.username = user.login
                return vc
            }

        case (1, 0):
            if let vc = UIStoryboard(name: "Repos", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("repoListViewController") as? RepoListViewController {
                vc.type = .All
                return vc
            }

        case (1, 1):
            if let vc = UIStoryboard(name: "Repos", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("repoListViewController") as? RepoListViewController {
                vc.type = .Public
                return vc
            }

        case (1, 1):
            if let vc = UIStoryboard(name: "Repos", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("repoListViewController") as? RepoListViewController {
                vc.type = .Private
                return vc
            }

        case (2, 0):
            if let vc = UIStoryboard(name: "Gists", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("gistListViewController") as? GistListViewController {
                return vc
            }
            
        default:
            break
        }
        
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
