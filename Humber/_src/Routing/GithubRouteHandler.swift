// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

internal class GithubRouteHandler: NSObject {
    private weak var rootViewController: RootViewController?
    
    internal init(rootViewController: RootViewController) {
        self.rootViewController = rootViewController
        
        super.init()
    
        self.setupAccountRouting()
        self.setupIssueRouting()
        self.setupRepoRouting()
        self.setupOverviewRouting()
    }
    
    private func setupAccountRouting() {
        Router.addRoute(GithubRoutes.followersTemplate, source: .All, permissions: []) { info in
            guard let vc = UIStoryboard(name: "Account", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("accountFollowersViewController") as? AccountFollowersViewController else {
                return false
            }
            
            vc.username = info["username"] as? String
            self.rootViewController?.currentNavigationController()?.pushViewController(vc, animated: true)
            
            return true
        }
        
        Router.addRoute(GithubRoutes.followingTemplate, source: .All, permissions: []) { info in
            guard let vc = UIStoryboard(name: "Account", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("accountFollowingViewController") as? AccountFollowingViewController else {
                return false
            }
            
            vc.username = info["username"] as? String
            self.rootViewController?.currentNavigationController()?.pushViewController(vc, animated: true)
            
            return true
        }
        
        Router.addRoute(GithubRoutes.gistsTemplate, source: .All, permissions: []) { info in
            guard let vc = UIStoryboard(name: "Gists", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("gistListViewController") as? GistListViewController else {
                return false
            }
            
            self.rootViewController?.currentNavigationController()?.pushViewController(vc, animated: true)
            return true
        }
        
        Router.addRoute(GithubRoutes.reposTemplate, source: .All, permissions: []) { info in
            guard let vc = UIStoryboard(name: "Repos", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("repoListViewController") as? RepoListViewController,
                let type = GithubRepoType(rawValue: info["type"] as? String ?? "") else {
                    return false
            }
            
            vc.type = type
            self.rootViewController?.currentNavigationController()?.pushViewController(vc, animated: true)
            return true
        }
    }
    
    private func setupIssueRouting() {
        Router.addRoute(GithubRoutes.singleIssueTemplate, source: .All, permissions: []) { info in
            guard let vc = UIStoryboard(name: "Issues", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("issueViewController") as? IssueViewController else {
                return false
            }
            
            vc.repoOwner = info["username"] as? String ?? ""
            vc.repoName = info["repoName"] as? String ?? ""
            vc.issueNumber = info["issueNumber"] as? String ?? ""
            
            self.rootViewController?.currentNavigationController()?.pushViewController(vc, animated: true)
            
            return true
        }
    }
    
    private func setupRepoRouting() {
        Router.addRoute(GithubRoutes.singleRepoTemplate, source: .All, permissions: []) { info in
            guard let vc = UIStoryboard(name: "Repos", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("repoViewController") as? RepoViewController else {
                return false
            }
            
            vc.repoOwner = info["username"] as? String
            vc.repoName = info["repoName"] as? String

            self.rootViewController?.currentNavigationController()?.pushViewController(vc, animated: true)
            return true
        }
    }
    
    private func setupOverviewRouting() {
        Router.addRoute(GithubRoutes.editOverview, source: .All, permissions: []) { info in
            guard let vc = UIStoryboard(name: "Main", bundle: Bundle.mainBundle()).instantiateViewControllerWithIdentifier("editOverviewViewController") as? EditOverviewViewController else {
                return false
            }
            
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .FormSheet
            
            self.rootViewController?.presentViewController(navVC, animated: true, completion: nil)
            return true
        }
    }
}
