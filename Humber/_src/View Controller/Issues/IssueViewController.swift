// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

// =======================================================

class IssueViewController: UITableViewController, PullToRefreshProviding, TableDividerUpdating, UIViewControllerPreviewingDelegate {
    internal var repoOwner = ""
    internal var repoName = ""
    internal var issueNumber = ""
    internal var issue: GithubIssueModel?

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
// =======================================================
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupBarButtonItems()
        self.setupNavigationItemTitle()
        self.setupPullToRefresh(self, action: #selector(IssueViewController.sync))
        self.updateTableDivider()
        
        self.fetch()
        
        if self.traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(IssueViewController.didChangeTheme), name: Theme.themeChangedNotification, object: nil)
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
    
    private func setupTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
    }
    
    private func setupBarButtonItems() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(IssueViewController.didTapShare(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func setupNavigationItemTitle() {
        self.navigationItem.title = "Issue"
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

            self.issue = ServiceController.component(GithubIssueDataProviding.self)?.issue(repoName: self.repoName, issueNumber: Int(self.issueNumber) ?? 0)
            self.tableView.reloadData()
        }
    }
    
    @objc private func sync() {
        ServiceController.component(GithubIssueSyncProviding.self)?.syncIssue(repoOwner: self.repoOwner, repoName: self.repoName, issueNumber: self.issueNumber).startWithNext { self.fetch() }
    }
    
// =======================================================
// MARK: - Actions
    
    @objc private func didTapShare(sender: UIBarButtonItem) {
        guard let issue = self.issue,
            let repo = issue.repository,
            let activityVC = ServiceController.component(ShareProviding.self)?.share(url: "https://github.com/\(repo.fullName)/issues") else {
                return
        }
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = self.issue else {
            return 0
        }
        
        switch section {
        case 0:
            return 1
            
        case 1:
            return 2
            
        case 2:
            return 3
            
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 22.0
            
        case 1:
            return 28.0
            
        case 2:
            return 28.0
            
        default:
            return CGFloat.min
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
            
        case 1:
            let view = PlainTableSectionHeaderView(frame: CGRect.zero)
            view.render(text: "Status")
            return view
            
        case 2:
            let view = PlainTableSectionHeaderView(frame: CGRect.zero)
            view.render(text: "Details")
            return view
            
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60.0
            
        default:
            return 44.0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let issue = self.issue else {
            return UITableViewCell()
        }
        
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            if let cell = tableView.dequeueReusableCellWithIdentifier("IssueHeaderCell") as? IssueHeaderCell {
                cell.render(model: issue)
                return cell
            }
            
        case (1, 0):
            if let cell = tableView.dequeueReusableCellWithIdentifier("IssueSingleDetailCell") as? IssueSingleDetailCell {
                cell.render(title: "Status:", text: issue.state.capitalizedString ?? "Open")
                return cell
            }
            
        case (1, 1):
            if let cell = tableView.dequeueReusableCellWithIdentifier("IssueSingleDetailCell") as? IssueSingleDetailCell {
                cell.render(title: "Last Updated:", text: "")
                return cell
            }

        case (2, 0):
            if let cell = tableView.dequeueReusableCellWithIdentifier("IssueSingleDetailCell") as? IssueSingleDetailCell {
                cell.render(title: "Repo:", text: issue.repository?.fullName ?? "\(self.repoOwner)/\(self.repoName)")
                cell.accessoryType = .DisclosureIndicator
                return cell
            }
           
        case (2, 1):
            if let cell = tableView.dequeueReusableCellWithIdentifier("IssueSingleDetailCell") as? IssueSingleDetailCell {
                cell.render(title: "Reporter:", text: issue.user?.login ?? "")
                return cell
            }

        case (2, 2):
            if let cell = tableView.dequeueReusableCellWithIdentifier("IssueSingleDetailCell") as? IssueSingleDetailCell {
                cell.render(title: "Assignee:", text: issue.assignee?.login ?? "")
                return cell
            }

        default:
            break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (2, 0):
            Router.route(path: GithubRoutes.singleRepo(username: self.repoOwner, repoName: self.repoName), source: .UserInitiated)
            
        default:
            break
        }
    }
    
// =======================================================
// MARK: - Force Touch
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location),
            let issue = self.issue else {
                return nil
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            guard let vc = UIStoryboard(name: "Repos", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("repoViewController") as? RepoViewController else {
                return nil
            }
            
            vc.repoName = issue.repository?.name
            vc.repoOwner = issue.repository?.owner?.login
            return vc
        }
        
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }

}
