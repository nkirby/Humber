// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class IssueHeaderCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
        self.descriptionLabel.text = ""
    }
    
// =======================================================

    internal func render(model model: GithubIssueModel) {
        self.backgroundColor = Theme.color(type: .CellBackgroundColor)

        let titleAttrString = NSAttributedString(string: "#\(model.issueNumber) \(model.title)", attributes: [
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor),
            NSFontAttributeName: Theme.font(type: .Bold(14.0))
        ])
        
        self.titleLabel.attributedText = titleAttrString
        
        let descAttrString = NSAttributedString(string: model.body, attributes: [
            NSForegroundColorAttributeName: Theme.color(type: .SecondaryTextColor),
            NSFontAttributeName: Theme.font(type: .Regular(12.0))
        ])
        
        self.descriptionLabel.attributedText = descAttrString
    }
}
