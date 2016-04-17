//
//  LoginPromptViewController.swift
//  Humber
//
//  Created by Nathaniel Kirby on 4/15/16.
//  Copyright © 2016 projectspong. All rights reserved.
//

import UIKit
import SafariServices

import HMCore
import HMGithub

class LoginPromptViewController: UIViewController {

    @IBOutlet var introLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.introLabel.font = Font.regular(size: 16.0)
        self.introLabel.text = "Log Into Github"
        
        self.loginButton.backgroundColor = UIColor(red: 75.0/255.0, green: 133.0/255.0, blue: 17.0/255.0, alpha: 1.0)
        
        let attrString = NSAttributedString(string: "Login", attributes: [
            NSFontAttributeName: Font.bold(size: 12.0),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ])
        
        self.loginButton.setAttributedTitle(attrString, forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
