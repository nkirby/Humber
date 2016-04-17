// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import UIKit

public class Font: NSObject {
    public static func bold(size size: CGFloat) -> UIFont {
        return UIFont(name: "Hack-Bold", size: size)!
    }
    
    public static func regular(size size: CGFloat) -> UIFont {
        return UIFont(name: "Hack-Regular", size: size)!
    }
    
    public static func italic(size size: CGFloat) -> UIFont {
        return UIFont(name: "Hack-Italic", size: size)!
    }
}
