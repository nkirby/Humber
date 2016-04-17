// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

// =======================================================

class RepoListViewController: UITableViewController, PullToRefreshProviding {
    internal var type = GithubRepoType.All

    private var tableSectionOwned = Int.min
    private var tableSectionContributed = Int.min
    private var tableSectionCount = 0
    
    private var ownedRepos = [GithubRepoModel]()
    private var contributedRepos = [GithubRepoModel]()

// =======================================================
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationItemTitle()
        self.setupTableView()
        self.setupPullToRefresh(self, action: #selector(RepoListViewController.sync))

        self.fetch()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sync()
    }

// =======================================================
// MARK: - Setup
    
    private func setupNavigationItemTitle() {
        self.navigationItem.title = "\(self.type.rawValue.capitalizedString) Repos"
    }
    
    private func setupTableView() {
        self.tableView.rowHeight = 60.0
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
    }
    
// =======================================================
// MARK: - Data Lifecycle
    
    private func fetch() {
        Async.main {
            self.refreshControl?.endRefreshing()
            
            guard let data = ServiceController.component(GithubAccountRepoDataFetchProviding.self) else {
                return
            }
            
            switch self.type {
            case .All:
                self.ownedRepos = (data.currentAccountOwnedPublicRepos() + data.currentAccountOwnedPrivateRepos()).sort { $0.fullName > $1.fullName }
                self.contributedRepos = (data.currentAccountContributedPublicRepos() + data.currentAccountContributedPrivateRepos()).sort { $0.fullName > $1.fullName }
                
            case .Public:
                self.ownedRepos = (data.currentAccountOwnedPublicRepos()).sort { $0.fullName > $1.fullName }
                self.contributedRepos = (data.currentAccountContributedPublicRepos()).sort { $0.fullName > $1.fullName }
                
            case .Private:
                self.ownedRepos = (data.currentAccountOwnedPrivateRepos()).sort { $0.fullName > $1.fullName }
                self.contributedRepos = (data.currentAccountContributedPrivateRepos()).sort { $0.fullName > $1.fullName }
            }
            
            var count = 0
            
            if self.ownedRepos.count > 0 {
                self.tableSectionOwned = count
                count += 1
            } else {
                self.tableSectionOwned = Int.min
            }
            
            if self.contributedRepos.count > 0 {
                self.tableSectionContributed = count
                count += 1
            } else {
                self.tableSectionContributed = Int.min
            }
            
            self.tableSectionCount = count
            self.tableView.reloadData()
        }
    }
    
    @objc private func sync() {
        ServiceController.component(GithubAccountRepoSyncProviding.self)?.syncAccountRepos(type: self.type).startWithNext { self.fetch() }
    }
    
    
// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.tableSectionCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case self.tableSectionOwned:
            return self.ownedRepos.count
            
        case self.tableSectionContributed:
            return self.contributedRepos.count
            
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == self.tableSectionOwned || section == self.tableSectionContributed {
            return 32.0
        }
        
        return CGFloat.min
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case self.tableSectionOwned:
            let view = PlainTableSectionHeaderView(frame: CGRect.zero)
            view.render(text: "Owned")
            return view
            
        case self.tableSectionContributed:
            let view = PlainTableSectionHeaderView(frame: CGRect.zero)
            view.render(text: "Contributed")
            return view
            
        default:
            return nil
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SingleRepoCell") as? SingleRepoCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case self.tableSectionOwned:
            guard let repo = self.ownedRepos.get(indexPath.row) else {
                return UITableViewCell()
            }

            cell.render(model: repo)
            cell.accessoryType = .DisclosureIndicator
            return cell

        case self.tableSectionContributed:
            guard let repo = self.contributedRepos.get(indexPath.row) else {
                return UITableViewCell()
            }
            
            cell.render(model: repo)
            cell.accessoryType = .DisclosureIndicator
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.section {
        case self.tableSectionOwned:
            if let repo = self.ownedRepos.get(indexPath.row), let owner = repo.owner {
                Router.route(path: GithubRoutes.singleRepo(username: owner.login, repoName: repo.name), source: .UserInitiated)
            }
            
        case self.tableSectionContributed:
            if let repo = self.contributedRepos.get(indexPath.row), let owner = repo.owner {
                Router.route(path: GithubRoutes.singleRepo(username: owner.login, repoName: repo.name), source: .UserInitiated)
            }
            
        default:
            break
        }
    }
}
