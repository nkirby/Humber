// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

// =======================================================

class IssuesListViewController: UITableViewController, NavigationBarUpdating, PullToRefreshProviding {
    private var issues = [GithubIssueModel]()
    
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
        self.setupPullToRefresh()
        self.setupPullToRefresh(self, action: #selector(IssuesListViewController.sync))
        
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
        self.navigationItem.title = "Issues"
    }
    
    private func setupTableView() {
        self.tableView.rowHeight = 60.0
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
    }
    
    private func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(IssuesListViewController.load), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }
    
// =======================================================
// MARK: - Data Lifecycle
    
    private func fetch() {
        Async.main {
            self.refreshControl?.endRefreshing()
            
            guard let issues = ServiceController.component(GithubAccountIssuesDataProviding.self)?.currentAccountIssues() else {
                return
            }
            
            self.issues = issues
            self.tableView.reloadData()
        }
    }
    
    @objc private func sync() {
        ServiceController.component(GithubAccountIssuesSyncProviding.self)?.syncAccountIssues().startWithNext { self.fetch() }
    }
    
    
// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.issues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let issue = self.issues.get(indexPath.row),
            let cell = tableView.dequeueReusableCellWithIdentifier("SingleIssueCell") as? SingleIssueCell else {
                return UITableViewCell()
        }
        
        cell.render(model: issue)
        cell.accessoryType = .DisclosureIndicator
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let issue = self.issues.get(indexPath.row),
            let repo = issue.repository,
            let owner = repo.owner else {
                return
        }
        
        Router.route(path: GithubRoutes.singleIssue(username: owner.login, repoName: repo.name, number: issue.issueNumber), source: .UserInitiated)
    }
}
