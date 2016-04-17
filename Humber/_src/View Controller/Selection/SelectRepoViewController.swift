// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

internal protocol SelectRepoDelegate: class {
    func didSelectRepo(model model: GithubRepoModel)
}

// =======================================================

class SelectRepoViewController: UITableViewController, PullToRefreshProviding, TableDividerUpdating {
    internal weak var delegate: SelectRepoDelegate?
    
    private var repos = [GithubRepoModel]()

// =======================================================
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupNavigationItemTitle()
        self.setupPullToRefresh(self, action: #selector(SelectRepoViewController.sync))
        self.updateTableDivider()
        
        self.fetch()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sync()
    }
    
// =======================================================
// MARK: - Setup
    
    private func setupTableView() {
        self.tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
        
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setupNavigationItemTitle() {
        self.navigationItem.title = "Repo"
    }
    
// =======================================================
// MARK: - Data Lifecycle
    
    private func fetch() {
        Async.main {
            self.refreshControl?.endRefreshing()
            
            guard let repos = ServiceController.component(GithubAccountRepoDataFetchProviding.self)?.currentAccountRepos() else {
                return
            }
            
            self.repos = repos
            self.tableView.reloadData()
        }
    }
    
    @objc private func sync() {
        ServiceController.component(GithubAccountRepoSyncProviding.self)?.syncAccountRepos(type: .All).startWithNext { self.fetch() }
    }
    
// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 28.0
            
        default:
            return CGFloat.min
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let view = PlainTableSectionHeaderView()
            view.render(text: "Your Repos")
            return view
            
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "repoCell")
        
        if let model = self.repos.get(indexPath.row) {
            cell.textLabel?.attributedText = NSAttributedString(string: model.fullName, attributes: [
                NSFontAttributeName: Theme.font(type: .Bold(14.0)),
                NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor)
            ])
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let repo = self.repos.get(indexPath.row) else {
            return
        }
        
        self.delegate?.didSelectRepo(model: repo)
    }
}
