// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class IssueSingleDetailCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
        self.valueLabel.text = ""
    }
    
// =======================================================

    internal func render(title title: String, text: String) {
        self.backgroundColor = Theme.color(type: .CellBackgroundColor)

        let titleAttrString = NSAttributedString(string: title, attributes: [
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor),
            NSFontAttributeName: Theme.font(type: .Regular(12.0))
        ])
        
        self.titleLabel.attributedText = titleAttrString
        
        let valueAttrString = NSAttributedString(string: text, attributes: [
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor),
            NSFontAttributeName: Theme.font(type: .Bold(12.0))
        ])
        
        self.valueLabel.attributedText = valueAttrString
    }
}
