// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class EditOverviewItemViewController: UITableViewController {
    internal var itemModel: GithubOverviewItemModel?
    
    private var itemTitle = ""
    private var itemRepoName = ""
    private var itemRepoOwner = ""
    private var itemAction: GithubOverviewItemAction?
    
    private var tableSectionName = Int.min
    private var tableSectionStats = Int.min
    private var tableSectionCount = 0
    
// =======================================================

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupNavigationItemTitle()
        self.setupTableSections()
        self.setupBarButtonItems()
        
        if let model = self.itemModel {
            self.itemTitle = model.title
            self.itemRepoName = model.repoName
            self.itemRepoOwner = model.repoOwner
            self.itemAction = GithubOverviewItemAction(rawValue: model.action)
        }
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
        self.navigationItem.title = self.itemModel?.title ?? ""
    }
    
    private func setupTableSections() {
        guard let model = self.itemModel else {
            return
        }

        self.tableSectionName = 0

        if model.type != "divider" {
            self.tableSectionStats = 1
            self.tableSectionCount = 2
        } else {
            self.tableSectionCount = 1
        }
    }
    
    private func setupBarButtonItems() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(EditOverviewItemViewController.didTapCancel))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(EditOverviewItemViewController.didTapSave))
        self.navigationItem.rightBarButtonItem = saveButton
    }

// =======================================================
// MARK: - Actions
    
    @objc private func didTapCancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc private func didTapSave() {
        guard let model = self.itemModel else {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        
        if model.type == "divider" {
            ServiceController.component(GithubOverviewSyncProviding.self)?.editOverviewItem(itemID: model.itemID, title: self.itemTitle).startWithNext {
                self.navigationController?.popViewControllerAnimated(true)
            }
            
        } else {
            ServiceController.component(GithubOverviewSyncProviding.self)?.editOverviewItem(itemID: model.itemID, title: self.itemTitle, repoName: self.itemRepoName, repoOwner: self.itemRepoOwner, type: self.itemAction?.rawValue ?? GithubOverviewItemAction.Issues.rawValue, threshold: -1).startWithNext {
                    self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableSectionCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case self.tableSectionName:
            return 1
            
        case self.tableSectionStats:
            return 2
            
        default:
            return 0
            
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case self.tableSectionName, self.tableSectionStats:
            return 28.0
            
        default:
            return CGFloat.min
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case self.tableSectionName:
            let view = PlainTableSectionHeaderView()
            view.render(text: "Name")
            return view
            
        case self.tableSectionStats:
            let view = PlainTableSectionHeaderView()
            view.render(text: "Info")
            return view
            
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let model = self.itemModel else {
            return UITableViewCell()
        }
        
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            if let cell = tableView.dequeueReusableCellWithIdentifier("EditOverviewItemTitleCell") as? EditOverviewItemTitleCell {
                cell.render(model: model, delegate: self)
                return cell
            }
            
        case (1, 0):
            if let cell = tableView.dequeueReusableCellWithIdentifier("EditOverviewItemValueCell") as? EditOverviewItemValueCell {
                if self.itemRepoOwner != "" {
                    cell.render(title: "Repo", value: "\(self.itemRepoOwner)/\(self.itemRepoName)")
                } else {
                    cell.render(title: "Repo", value: "")
                }
                
                cell.accessoryType = .DisclosureIndicator
                return cell
            }

        case (1, 1):
            if let cell = tableView.dequeueReusableCellWithIdentifier("EditOverviewItemValueCell") as? EditOverviewItemValueCell {
                cell.render(title: "Type", value: self.itemAction?.rawValue.capitalizedString ?? "")
                cell.accessoryType = .DisclosureIndicator
                return cell
            }

        case (1, 2):
            if let cell = tableView.dequeueReusableCellWithIdentifier("EditOverviewItemValueCell") as? EditOverviewItemValueCell {
                cell.render(title: "Threshold", value: GithubOverviewItemThreshold.stringValue(threshold: model.threshold))
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
        
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("selectRepoViewController") as? SelectRepoViewController {
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case (1, 1):
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("selectItemTypeViewController") as? SelectItemTypeViewController {
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        default:
            break
        }
    }
}

// =======================================================

extension EditOverviewItemViewController: EditOverviewTitleDelegate {
    var tapGestureView: UIView {
        return self.view
    }
    
    func didUpdateTitle(title title: String) {
        self.itemTitle = title
    }
}

extension EditOverviewItemViewController: SelectRepoDelegate {
    func didSelectRepo(model model: GithubRepoModel) {
        self.itemRepoName = model.name
        self.itemRepoOwner = model.owner?.login ?? ""
        
        self.tableView.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension EditOverviewItemViewController: SelectItemActionDelegate {
    func didSelectAction(action action: GithubOverviewItemAction) {
        self.itemAction = action
        
        self.tableView.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
    }
}
