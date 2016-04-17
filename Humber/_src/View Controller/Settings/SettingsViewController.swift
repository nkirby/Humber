// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore

// =======================================================

class SettingsViewController: UITableViewController, NavigationBarUpdating, TableDividerUpdating {
    private let tableSectionTheme = 0
    private let tableSectionCount = 1
    
    private var themes = [String]()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

// =======================================================
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupNavigationItem()
        self.setupNavigationBarStyling()
        self.updateTableDivider()
    
        self.loadThemes()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsViewController.didChangeTheme), name: Theme.themeChangedNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// =======================================================
// MARK: - Setup
    
    private func setupTableView() {
        self.tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
    }
    
    private func setupNavigationItem() {
        self.navigationItem.title = "Settings"
        
        let closeButton = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(SettingsViewController.didTapClose))
        self.navigationItem.leftBarButtonItem = closeButton
        
        let logoutButton = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: #selector(SettingsViewController.didTapLogout))
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc private func didChangeTheme() {
        self.tableView.backgroundColor = Theme.color(type: .ViewBackgroundColor)
        
        self.updateTableDivider()
        self.setupNavigationBarStyling()
    }

// =======================================================
// MARK: - Data
    
    private func loadThemes() {
        self.themes = Theme.themes.map { $0.name }
    }

// =======================================================
// MARK: - Actions
    
    @objc private func didTapClose() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func didTapLogout() {
        self.dismissViewControllerAnimated(true, completion: {
            ServiceController.sharedController.logout()
        })
    }
    
// =======================================================
// MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableSectionCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case self.tableSectionTheme:
            return self.themes.count
            
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case self.tableSectionTheme:
            return 28.0
            
        default:
            return CGFloat.min
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case self.tableSectionTheme:
            let view = PlainTableSectionHeaderView()
            view.render(text: "Theme")
            return view
            
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "settingsCell")
        cell.tintColor = Theme.color(type: .TintColor)
        cell.backgroundColor = Theme.color(type: .CellBackgroundColor)
        
        switch indexPath.section {
        case self.tableSectionTheme:
            if let theme = self.themes.get(indexPath.row) {
                cell.textLabel?.attributedText = NSAttributedString(string: theme, attributes: [
                    NSFontAttributeName: Theme.font(type: .Regular(12.0)),
                    NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor)
                ])
                
                if theme == Theme.currentThemeName() {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            }
            
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.section {
        case tableSectionTheme:
            if let theme = self.themes.get(indexPath.row) {
                Theme.activateTheme(themeName: theme)
                self.tableView.reloadSections(NSIndexSet(index: self.tableSectionTheme), withRowAnimation: .None)
            }
            
        default:
            break
        }
    }
}
