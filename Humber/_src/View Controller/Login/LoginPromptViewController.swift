// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import SafariServices

import HMCore
import HMGithub

// =======================================================

class LoginPromptViewController: UIViewController {
    @IBOutlet var introLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    
// =======================================================
// MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Theme.color(type: .ViewBackgroundColor)
        
        // Do any additional setup after loading the view.
        self.introLabel.font = Font.bold(size: 18.0)
        self.introLabel.textColor = Theme.color(type: .PrimaryTextColor)
        self.introLabel.text = "Log Into Github"
        
        self.loginButton.backgroundColor = Theme.color(type: .TintColor)
        
        let attrString = NSAttributedString(string: "Login", attributes: [
            NSFontAttributeName: Font.bold(size: 12.0),
            NSForegroundColorAttributeName: Theme.color(type: .ViewBackgroundColor)
        ])
        
        self.loginButton.setAttributedTitle(attrString, forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// =======================================================
// MARK: - Actions
    
    @IBAction func loginTapped(sender: AnyObject) {
        guard let loginController = ServiceController.component(GithubLoginRequestProviding.self) else {
            return
        }        
        
        do {
            let request = try loginController.createLoginRequest()
            guard let url = NSURL(string: request.requestURL) else {
                return
            }
            
            let sfvc = SFSafariViewController(URL: url)
            loginController.loginSignal.observeNext { success in
                self.dismissViewControllerAnimated(true, completion: nil)
            }

            self.presentViewController(sfvc, animated: true, completion: nil)
            
        } catch {
        }
    }

}
