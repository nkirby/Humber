// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

// =======================================================

class RootTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let idx = NSUserDefaults.standardUserDefaults().integerForKey("HMSelectedTabKey")
        self.selectedIndex = idx
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// =======================================================

    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if let idx = tabBar.items?.indexOf(item) {
            NSUserDefaults.standardUserDefaults().setValue(idx, forKey: "HMSelectedTabKey")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

}
