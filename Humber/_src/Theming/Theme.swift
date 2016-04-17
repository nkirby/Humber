// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

// =======================================================

internal final class Theme: NSObject {
    private(set) internal static var themes = [Themable]()
    internal static let themeChangedNotification = "HMThemeDidChangeNotification"
    
    internal static func registerThemes(themes themes: [Themable]) {
        self.themes = themes
    }
    
    internal static func activateTheme(themeName name: String) {
        NSUserDefaults.standardUserDefaults().setValue(name, forKey: "HMCurrentThemeName")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(self.themeChangedNotification, object: nil)
    }
    
    private static func currentTheme() -> Themable {
        let themeName = NSUserDefaults.standardUserDefaults().stringForKey("HMCurrentThemeName")
        
        if let theme = self.themes.filter({ $0.name == themeName }).first {
            return theme
        } else {
            return self.themes.first!
        }
    }
    
    internal static func color(type type: ColorType) -> UIColor {
        return self.currentTheme().color(type: type)
    }
    
    internal static func font(type type: FontType) -> UIFont {
        return self.currentTheme().font(type: type)
    }
    
    internal static func currentThemeName() -> String {
        return self.currentTheme().name
    }
    
    internal static func currentThemeIsDark() -> Bool {
        return self.currentTheme().name == "Dark"
    }
}
