// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore

// =======================================================

class SingleRepoLinkCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

// =======================================================

    internal func render(text text: String) {
        let textAttrString = NSAttributedString(string: text, attributes: [
            NSFontAttributeName: Theme.font(type: .Bold(14.0)),
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor)
        ])
        
        self.titleLabel.attributedText = textAttrString
    }
}
