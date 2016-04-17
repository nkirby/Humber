// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class SingleGistCell: UITableViewCell {
    @IBOutlet var gistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    internal func render(model model: GithubGistModel) {
        let attrString = NSAttributedString(string: model.gistDescription, attributes: [
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor),
            NSFontAttributeName: Theme.font(type: .Bold(12.0))
        ])
        
        self.gistNameLabel.attributedText = attrString
    }
}
