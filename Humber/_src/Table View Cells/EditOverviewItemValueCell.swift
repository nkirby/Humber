// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class EditOverviewItemValueCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

// =======================================================

    internal func render(title title: String, value: String) {
        let titleAttrString = NSAttributedString(string: title, attributes: [
            NSFontAttributeName: Theme.font(type: .Bold(14.0)),
            NSForegroundColorAttributeName: Theme.color(type: .TintColor)
        ])
        
        self.titleLabel.attributedText = titleAttrString
        
        let valueAttrString = NSAttributedString(string: "\"\(value)\"", attributes: [
            NSFontAttributeName: Theme.font(type: .Regular(14.0)),
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor)
        ])
        
        self.valueLabel.attributedText = valueAttrString
    }
}
