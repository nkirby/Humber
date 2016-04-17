// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class SingleRepoCell: UITableViewCell {
    @IBOutlet var repoTitleLabel: UILabel!
    @IBOutlet var repoDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

// =======================================================

    internal func render(model model: GithubRepoModel) {
        let titleAttrString = NSAttributedString(string: model.fullName, attributes: [
            NSFontAttributeName: Theme.font(type: .Bold(14.0)),
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor)
        ])
        
        self.repoTitleLabel.attributedText = titleAttrString
        
        if model.repoDescription != "" {
            let descAttrString = NSAttributedString(string: model.repoDescription, attributes: [
                NSFontAttributeName: Theme.font(type: .Regular(12.0)),
                NSForegroundColorAttributeName: Theme.color(type: .SecondaryTextColor)
            ])
            
            self.repoDescriptionLabel.attributedText = descAttrString

        } else {
            let descAttrString = NSAttributedString(string: "None Specified", attributes: [
                NSFontAttributeName: Theme.font(type: .Italic(12.0)),
                NSForegroundColorAttributeName: Theme.color(type: .SecondaryTextColor)
            ])
            
            self.repoDescriptionLabel.attributedText = descAttrString
    
        }
    }
}
