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

class GistListViewController: UITableViewController, PullToRefreshProviding {
    private var gists = [GithubGistModel]()

// =======================================================
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationItem()
        self.setupTableView()
        self.setupPullToRefresh(self, action: #selector(GistListViewController.sync))
        
        self.fetch()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sync()
    }
    
// =======================================================
// MARK: - Setup
    
    private func setupNavigationItem() {
        self.navigationItem.title = "Public Gists"
    }
    
    private func setupTableView() {
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
    }
    
// =======================================================
// MARK: - Data Lifecycle
    
    private func fetch() {
        Async.main {
            self.refreshControl?.endRefreshing()
            
            if let gists = ServiceController.component(GithubAccountGistDataProviding.self)?.currentAccountGists() {
                self.gists = gists
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func sync() {
        ServiceController.component(GithubAccountGistsSyncProviding.self)?.syncCurrentAccountGists().startWithNext { self.fetch() }
    }

// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gists.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let gist = self.gists.get(indexPath.row),
            let cell = tableView.dequeueReusableCellWithIdentifier("SingleGistCell") as? SingleGistCell else {
                return UITableViewCell()
        }
        
        cell.render(model: gist)
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let gist = self.gists.get(indexPath.row),
            let url = NSURL(string: gist.htmlURL) else {
                return
        }
        
        let sfvc = SFSafariViewController(URL: url)
        sfvc.modalPresentationStyle = .FormSheet
        self.presentViewController(sfvc, animated: true, completion: nil)
    }
}
