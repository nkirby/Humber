// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class SingleRepoHeaderCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    internal func render(model model: GithubRepoModel) {
        let titleAttrString = NSAttributedString(string: model.name, attributes: [
            NSFontAttributeName: Theme.font(type: .Bold(16.0)),
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor)
        ])
        
        self.titleLabel.attributedText = titleAttrString
        
        if model.repoDescription != "" {
            let descAttrString = NSAttributedString(string: model.repoDescription, attributes: [
                NSFontAttributeName: Theme.font(type: .Regular(12.0)),
                NSForegroundColorAttributeName: Theme.color(type: .SecondaryTextColor)
            ])
            
            self.descriptionLabel.attributedText = descAttrString
            
        } else {
            let descAttrString = NSAttributedString(string: "None Specified", attributes: [
                NSFontAttributeName: Theme.font(type: .Italic(12.0)),
                NSForegroundColorAttributeName: Theme.color(type: .SecondaryTextColor)
            ])
            
            self.descriptionLabel.attributedText = descAttrString
            
        }
    }
}
