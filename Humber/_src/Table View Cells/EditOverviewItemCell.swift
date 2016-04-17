// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class EditOverviewItemCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    internal func render(model model: GithubOverviewItemModel) {
        let titleAttrString = NSAttributedString(string: model.type.capitalizedString, attributes: [
            NSFontAttributeName: Theme.font(type: .Bold(12.0)),
            NSForegroundColorAttributeName: Theme.color(type: .TintColor)
        ])
        
        self.titleLabel.attributedText = titleAttrString
        
        let valueAttrString = NSAttributedString(string: "\"\(model.title)\"", attributes: [
            NSFontAttributeName: Theme.font(type: .Regular(12.0)),
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor)
        ])
        
        self.valueLabel.attributedText = valueAttrString
    }
}
