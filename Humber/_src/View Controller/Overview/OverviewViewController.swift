// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async

import HMCore
import HMGithub

private let reuseIdentifier = "Cell"

// =======================================================

class OverviewViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NavigationBarUpdating {
    private var overviewItems = [GithubOverviewItemModel]()
    private var viewControllers = [OverviewItemSingleStatViewController]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.navigationController?.tabBarItem.imageInsets = UIEdgeInsets(top: 4.0, left: 0.0, bottom: -4.0, right: 0.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        self.setupNavigationBarStyling()
        self.setupNavigationItemTitle()
        self.setupBarButtonItems()
        
        self.fetch()
        
        if let notifName = ServiceController.component(GithubOverviewSyncProviding.self)?.didChangeOverviewNotification {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OverviewViewController.fetch), name: notifName, object: nil)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sync()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        Async.main {
            self.collectionView?.reloadData()
        }
    }
    
// =======================================================
// MARK: - Setup
    
    private func setupCollectionView() {
        self.collectionView?.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
        
        self.collectionView?.registerClass(OverviewDividerCollectionCell.self, forCellWithReuseIdentifier: "OverviewDividerCollectionCell")
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.registerClass(OverviewStatItemCollectionCell.self, forCellWithReuseIdentifier: "OverviewStatItemCollectionCell")
        
        self.collectionView?.backgroundColor = Theme.color(type: .ViewBackgroundColor)
        self.collectionView?.alwaysBounceVertical = true
//        self.collectionView?.alwaysBounceHorizontal = true
    }
    
    private func setupNavigationItemTitle() {
        self.navigationItem.title = "Overview"
    }
    
    private func setupBarButtonItems() {
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .Done, target: self, action: #selector(OverviewViewController.didTapEdit))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
// =======================================================
// MARK: - Data Lifecycle
    
    @objc private func fetch() {
        Async.main {
            if let items = ServiceController.component(GithubOverviewDataProviding.self)?.sortedOverviewItems() {
                self.overviewItems = items
                
                var currentVCs = [OverviewItemSingleStatViewController]()
                
                for item in items {
                    if item.type != "divider" {
                        if let vc = self.viewController(model: item) {
                            if !currentVCs.contains(vc) {
                                currentVCs.append(vc)
                            }
                        } else {
                            let vc = OverviewItemSingleStatViewController()
                            vc.itemModel = item
                            currentVCs.append(vc)
                        }
                    }
                }
                
                self.viewControllers = currentVCs
                self.collectionView?.reloadData()
            }
        }
    }
    
    private func sync() {
        self.viewControllers.forEach { $0.sync() }
    }
    
// =======================================================
// MARK: - View Controllers
    
    private func viewController(model model: GithubOverviewItemModel) -> OverviewItemSingleStatViewController? {
        return self.viewControllers.filter { $0.itemModel?.itemID == model.itemID }.first
    }
    
// =======================================================
// MARK: - Actions
    
    @objc private func didTapEdit() {
        Router.route(path: GithubRoutes.editOverview, source: .UserInitiated)
    }

// =======================================================
// MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.overviewItems.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let feedItem = self.overviewItems.get(indexPath.row) else {
            return CGSize(width: 1, height: 1)
        }
        
        switch feedItem.type {
        case "divider":
            return CGSize(width: collectionView.frame.size.width, height: 32.0)
            
        case "stats":
            return CGSize(width: collectionView.frame.size.width / 2.0, height: collectionView.frame.size.width / 2.0)
            
        default:
            break
        }
        
        return CGSize(width: collectionView.frame.size.width, height: 140.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat.min
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let feedItem = self.overviewItems.get(indexPath.row) else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
            return cell
        }
        
        switch feedItem.type {
        case "divider":
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OverviewDividerCollectionCell", forIndexPath: indexPath) as! OverviewDividerCollectionCell
            cell.render(model: feedItem)
            return cell
            
        case "stats":
            if let vc = self.viewController(model: feedItem) {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OverviewStatItemCollectionCell", forIndexPath: indexPath) as! OverviewStatItemCollectionCell
                cell.render(viewController: vc)
                return cell
            }
            
        default:
            break
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        return cell
    }
}
