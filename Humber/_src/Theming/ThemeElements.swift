// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

internal enum ColorType {
    case PrimaryTextColor
    case SecondaryTextColor
    case DisabledTextColor
    case TintColor
    case ViewBackgroundColor
    case CellBackgroundColor
}

internal enum FontType {
    case Bold(CGFloat)
    case Regular(CGFloat)
    case Italic(CGFloat)
}

internal protocol Themable {
    var name: String { get }
    
    func color(type type: ColorType) -> UIColor
    func font(type type: FontType) -> UIFont
}
