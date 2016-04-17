// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class ApplicationStyleController: NSObject {
    internal static func setupStyle() {
        self.setupThemes()

        self.setupNavigationBarStyling()
        self.setupBarButtonStyling()
    }
    
    private static func setupNavigationBarStyling() {
        UINavigationBar.appearance().tintColor = Theme.color(type: .TintColor)
    }
    
    private static func setupBarButtonStyling() {
        let attrs = [
            NSFontAttributeName: Theme.font(type: .Bold(14.0)),
            NSForegroundColorAttributeName: Theme.color(type: .TintColor)
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(attrs, forState: .Normal)
    }
    
    private static func setupThemes() {
        Theme.registerThemes(themes: [LightTheme(), DarkTheme()])
    }
}
