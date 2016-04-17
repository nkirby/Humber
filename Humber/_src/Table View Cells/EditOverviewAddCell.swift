// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class EditOverviewAddCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    internal func render() {
        let titleAttrString = NSAttributedString(string: "Add", attributes: [
            NSForegroundColorAttributeName: Theme.color(type: .TintColor),
            NSFontAttributeName: Theme.font(type: .Bold(14.0))
        ])
        
        self.titleLabel.attributedText = titleAttrString
    }
}
