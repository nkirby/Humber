// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

private enum EditFeedItem {
    case Add
    case Item(GithubOverviewItemModel)
}

// =======================================================

class EditOverviewViewController: UITableViewController, NavigationBarUpdating {
    private var feedItems = [EditFeedItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBarStyling()
        self.setupNavigationItemTitle()
        self.setupTableView()
        self.setupBarButtonItems()
        
        self.fetch()

        if let notifName = ServiceController.component(GithubOverviewSyncProviding.self)?.didChangeOverviewNotification {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditOverviewViewController.fetch), name: notifName, object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// =======================================================
// MARK: - Setup
    
    private func setupNavigationItemTitle() {
        self.navigationItem.title = "Edit"
    }
    
    private func setupTableView() {
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
    }
    
    private func setupBarButtonItems() {
        let closeButton = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(EditOverviewViewController.didTapClose))
        self.navigationItem.leftBarButtonItem = closeButton
        
        let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(EditOverviewViewController.didTapEdit))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
// =======================================================
// MARK: - Data Lifecycle
    
    @objc private func fetch() {
        Async.main {
            guard let items = ServiceController.component(GithubOverviewDataProviding.self)?.sortedOverviewItems() else {
                return
            }
            
            self.feedItems = items.map { EditFeedItem.Item($0) }
            self.feedItems.append(.Add)
            
            if self.feedItems.count == 1 && self.tableView.editing {
                self.didTapEdit()
            }
            
            self.tableView.reloadData()
        }
    }
    
// =======================================================
// MARK: - Actions
    
    @objc private func didTapClose() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func didTapEdit() {
        if self.tableView.editing {
            self.tableView.editing = false
            
            let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(EditOverviewViewController.didTapEdit))
            self.navigationItem.rightBarButtonItem = editButton

        } else {
            self.tableView.editing = true
            
            let editButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(EditOverviewViewController.didTapEdit))
            self.navigationItem.rightBarButtonItem = editButton
        }
    }
    
    @objc private func didTapAdd() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Divider", style: .Default, handler: { action in
            self.addDivider()
        }))

//        actionSheet.addAction(UIAlertAction(title: "Global Stats", style: .Default, handler: { action in
//            self.addGlobalStats()
//        }))

        actionSheet.addAction(UIAlertAction(title: "Repo Stats", style: .Default, handler: { action in
            self.addRepoStats()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        actionSheet.modalPresentationStyle = .FormSheet
        actionSheet.view.tintColor = Theme.color(type: .TintColor)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    private func addDivider() {
        ServiceController.component(GithubOverviewSyncProviding.self)?.addOverviewItem(type: "divider").start()
    }
    
    private func addGlobalStats() {
        
    }
    private func addRepoStats() {
        ServiceController.component(GithubOverviewSyncProviding.self)?.addOverviewItem(type: "stats").start()
    }
    
// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedItems.count
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let item = self.feedItems.get(indexPath.row) else {
            return false
        }
        
        switch item {
        case .Add:
            return false
            
        case .Item(_):
            return true
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let item = self.feedItems.get(indexPath.row) else {
            return
        }
        
        switch editingStyle {
        case .Delete:
            if case let .Item(model) = item {
                ServiceController.component(GithubOverviewSyncProviding.self)?.deleteOverviewItem(itemID: model.itemID).start()
            }
            
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let item = self.feedItems.get(indexPath.row) else {
            return false
        }
        
        switch item {
        case .Add:
            return false
            
        default:
            return true
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        guard let item = self.feedItems.get(sourceIndexPath.row) else {
            self.fetch()
            return
        }
        
        switch item {
        case .Item(let model):
            Async.background {
                ServiceController.component(GithubOverviewSyncProviding.self)?.moveOverviewItem(itemID: model.itemID, toPosition: destinationIndexPath.row).start()
            }
            
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if proposedDestinationIndexPath.row == self.feedItems.count - 1 {
            return NSIndexPath(forRow: self.feedItems.count - 2, inSection: 0)
        }
        
        return proposedDestinationIndexPath
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let item = self.feedItems.get(indexPath.row) else {
            return UITableViewCell()
        }
        
        switch item {
        case .Add:
            if let cell = tableView.dequeueReusableCellWithIdentifier("EditOverviewAddCell") as? EditOverviewAddCell {
                cell.render()
                return cell
            }
            
        case .Item(let model):
            if let cell = tableView.dequeueReusableCellWithIdentifier("EditOverviewItemCell") as? EditOverviewItemCell {
                cell.render(model: model)
                cell.accessoryType = .DisclosureIndicator
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let item = self.feedItems.get(indexPath.row) else {
            return
        }
        
        switch item {
        case .Add:
            self.didTapAdd()
            
        case .Item(let model):
            guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("editOverviewItemViewController") as? EditOverviewItemViewController else {
                return
            }
            
            vc.itemModel = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
