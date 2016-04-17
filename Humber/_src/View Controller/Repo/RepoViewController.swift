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

class RepoViewController: UITableViewController, PullToRefreshProviding, TableDividerUpdating, UIViewControllerPreviewingDelegate {
    internal var repoID: String?
    internal var repoName: String?
    internal var repoOwner: String?
    
    private var repo: GithubRepoModel?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
// =======================================================
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationItemTitle()
        self.setupBarButtonItem()
        self.setupTableView()
        self.setupPullToRefresh(self, action: #selector(RepoViewController.sync))
        self.updateTableDivider()
        
        self.fetch()
        
        if self.traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RepoViewController.didChangeTheme), name: Theme.themeChangedNotification, object: nil)
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
        self.navigationItem.title = "Repo"
    }
    
    private func setupBarButtonItem() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(RepoViewController.didTapShare))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }

    private func setupTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
            
            if let repoID = self.repoID {
                self.repo = ServiceController.component(GithubRepoDataProviding.self)?.repo(repoID: repoID)
            } else if let repoName = self.repoName, let repoOwner = self.repoOwner {
                self.repo = ServiceController.component(GithubRepoDataProviding.self)?.repo(repoName: repoName, repoOwner: repoOwner)
            }
            
            self.tableView.reloadData()
        }
    }
    
    @objc private func sync() {
        
    }
    
// =======================================================
// MARK: - Actions
    
    @objc private func didTapShare() {
        
    }
    
// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.repo != nil {
            return 3
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return 1
            
        case 2:
            return 5
            
        default:
            break
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 22.0
            
        case 1, 2:
            return 28.0
            
        default:
            return CGFloat.min
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let view = PlainTableSectionHeaderView()
            view.render(text: "Owner")
            return view
            
        case 2:
            let view = PlainTableSectionHeaderView()
            view.render(text: "Details")
            return view
            
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80.0
            
        default:
            return 44.0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let repo = self.repo else {
            return UITableViewCell()
        }
        
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            if let cell = tableView.dequeueReusableCellWithIdentifier("SingleRepoHeaderCell") as? SingleRepoHeaderCell {
                cell.render(model: repo)
                return cell
            }
            
        case (1, 0):
            if let cell = tableView.dequeueReusableCellWithIdentifier("AccountFollowedUserCell") as? AccountFollowedUserCell, let owner = repo.owner {
                cell.render(model: owner)
                return cell
            }
            
        case (2, 0):
            if let cell = tableView.dequeueReusableCellWithIdentifier("SingleRepoLinkCell") as? SingleRepoLinkCell {
                cell.render(text: "Issues")
                cell.accessoryType = .DisclosureIndicator
                return cell
            }
            
        case (2, 1):
            if let cell = tableView.dequeueReusableCellWithIdentifier("SingleRepoLinkCell") as? SingleRepoLinkCell {
                cell.render(text: "Pull Requests")
                cell.accessoryType = .DisclosureIndicator
                return cell
            }

        case (2, 2):
            if let cell = tableView.dequeueReusableCellWithIdentifier("SingleRepoLinkCell") as? SingleRepoLinkCell {
                cell.render(text: "Branches")
                cell.accessoryType = .DisclosureIndicator
                return cell
            }

        case (2, 3):
            if let cell = tableView.dequeueReusableCellWithIdentifier("SingleRepoLinkCell") as? SingleRepoLinkCell {
                cell.render(text: "Releases")
                cell.accessoryType = .DisclosureIndicator
                return cell
            }

        case (2, 4):
            if let cell = tableView.dequeueReusableCellWithIdentifier("SingleRepoLinkCell") as? SingleRepoLinkCell {
                cell.render(text: "Wiki")
                cell.accessoryType = .DisclosureIndicator
                return cell
            }

        default:
            break
        }
        
        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let repo = self.repo,
            let owner = repo.owner else {
                return
        }
        
        switch (indexPath.section, indexPath.row) {
        case (2, 0):
            if let url = NSURL(string: "https://github.com/\(owner.login)/\(repo.name)/issues") {
                let sfvc = SFSafariViewController(URL: url)
                sfvc.modalPresentationStyle = .FormSheet
                self.presentViewController(sfvc, animated: true, completion: nil)
            }
            
        case (2, 1):
            if let url = NSURL(string: "https://github.com/\(owner.login)/\(repo.name)/pulls") {
                let sfvc = SFSafariViewController(URL: url)
                sfvc.modalPresentationStyle = .FormSheet
                self.presentViewController(sfvc, animated: true, completion: nil)
            }
            
        case (2, 2):
            if let url = NSURL(string: "https://github.com/\(owner.login)/\(repo.name)/branches") {
                let sfvc = SFSafariViewController(URL: url)
                sfvc.modalPresentationStyle = .FormSheet
                self.presentViewController(sfvc, animated: true, completion: nil)
            }
            
        case (2, 3):
            if let url = NSURL(string: "https://github.com/\(owner.login)/\(repo.name)/releases") {
                let sfvc = SFSafariViewController(URL: url)
                sfvc.modalPresentationStyle = .FormSheet
                self.presentViewController(sfvc, animated: true, completion: nil)
            }
            
        case (2, 4):
            if let url = NSURL(string: "https://github.com/\(owner.login)/\(repo.name)/wiki") {
                let sfvc = SFSafariViewController(URL: url)
                sfvc.modalPresentationStyle = .FormSheet
                self.presentViewController(sfvc, animated: true, completion: nil)
            }
            
        default:
            break
        }
    }
    
// =======================================================
// MARK: - Force Touch
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location),
            let repo = self.repo,
            let owner = repo.owner else {
                return nil
        }
        
        switch (indexPath.section, indexPath.row) {
        case (2, 0):
            if let url = NSURL(string: "https://github.com/\(owner.login)/\(repo.name)/issues") {
                let sfvc = SFSafariViewController(URL: url)
                sfvc.modalPresentationStyle = .FormSheet
                return sfvc
            }
            
        case (2, 1):
            if let url = NSURL(string: "https://github.com/\(owner.login)/\(repo.name)/pulls") {
                let sfvc = SFSafariViewController(URL: url)
                sfvc.modalPresentationStyle = .FormSheet
                return sfvc
            }
            
        case (2, 2):
            if let url = NSURL(string: "https://github.com/\(owner.login)/\(repo.name)/branches") {
                let sfvc = SFSafariViewController(URL: url)
                sfvc.modalPresentationStyle = .FormSheet
                return sfvc
            }
            
        case (2, 3):
            if let url = NSURL(string: "https://github.com/\(owner.login)/\(repo.name)/releases") {
                let sfvc = SFSafariViewController(URL: url)
                sfvc.modalPresentationStyle = .FormSheet
                return sfvc
            }
            
        case (2, 4):
            if let url = NSURL(string: "https://github.com/\(owner.login)/\(repo.name)/wiki") {
                let sfvc = SFSafariViewController(URL: url)
                sfvc.modalPresentationStyle = .FormSheet
                return sfvc
            }

        default:
            break
        }
        
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.navigationController?.presentViewController(viewControllerToCommit, animated: true, completion: nil)
    }
}
