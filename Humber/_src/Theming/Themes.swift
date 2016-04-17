// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore

// =======================================================

class LightTheme: NSObject, Themable {
    let name = "Light"
    
    func color(type type: ColorType) -> UIColor {
        switch type {
        case .CellBackgroundColor:
            return UIColor.whiteColor()
            
        case .PrimaryTextColor:
            return UIColor(white: 0.1, alpha: 1.0)
            
        case .SecondaryTextColor:
            return UIColor(white: 0.35, alpha: 1.0)
            
        case .DisabledTextColor:
            return UIColor(white: 0.75, alpha: 1.0)
            
        case .TintColor:
            return UIColor(red: 75.0/255.0, green: 133.0/255.0, blue: 17.0/255.0, alpha: 1.0)
            
        case .ViewBackgroundColor:
            return UIColor(white: 0.98, alpha: 1.0)
        }
    }
    
    func font(type type: FontType) -> UIFont {
        switch type {
        case .Bold(let size):
            return Font.bold(size: size)
            
        case .Regular(let size):
            return Font.regular(size: size)
            
        case .Italic(let size):
            return Font.italic(size: size)
        }
    }
}
