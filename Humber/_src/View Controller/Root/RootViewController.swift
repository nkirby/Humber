//
//  RootViewController.swift
//  Humber
//
//  Created by Nathaniel Kirby on 4/15/16.
//  Copyright © 2016 projectspong. All rights reserved.
//

import UIKit
import HMCore
import SnapKit

class RootViewController: UIViewController {
    @IBOutlet var containerView: UIView!
    private var interfaceViewController: UIViewController?
    
    // Routing
    private var githubRouteHandler: GithubRouteHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.githubRouteHandler = GithubRouteHandler(rootViewController: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ServiceController.sharedController.currentUser.producer
            .filter { $0 != nil }
            .startWithNext { user in
                if user?.loggedIn == true {
                    self.updateInterface(user: user!)
                    
                } else {
                    self.displayLogin()
                }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.interfaceViewController?.view.frame = self.containerView.bounds
    }
    
    private func updateInterface(user user: ServiceContainer) {
        print("user? - \(user)")
        let vc = UIStoryboard(name: "Main", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("rootTabBarController") as! UITabBarController
        
        vc.tabBar.tintColor = UIColor(red: 75.0/255.0, green: 133.0/255.0, blue: 17.0/255.0, alpha: 1.0)
        self.containerView.addSubview(vc.view)
        self.addChildViewController(vc)
        
        self.containerView.backgroundColor = UIColor.blueColor()
        self.interfaceViewController = vc
    }
    
    private func displayLogin() {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("loginPromptVC") as! LoginPromptViewController
        
        vc.view.frame = self.containerView.bounds
        self.containerView.addSubview(vc.view)
        self.addChildViewController(vc)

        self.interfaceViewController = vc
    }
    
    internal func currentNavigationController() -> UINavigationController? {
        guard let tabsController = self.interfaceViewController as? UITabBarController,
            let vc = tabsController.selectedViewController else {
                return nil
        }
        
        return (vc as? UINavigationController)
    }
}
