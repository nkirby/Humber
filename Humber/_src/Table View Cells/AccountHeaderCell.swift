// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class AccountHeaderCell: UITableViewCell {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.avatarImageView.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2.0
    }
    
// =======================================================

    internal func render(model model: GithubAccountModel) {
        let nameAttrString = NSAttributedString(string: model.name, attributes: [
            NSFontAttributeName: Theme.font(type: .Bold(16.0)),
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor)
        ])

        self.nameLabel.attributedText = nameAttrString
        
        if model.bio != "" {
            let bioAttrString = NSAttributedString(string: model.bio, attributes: [
                NSFontAttributeName: Theme.font(type: .Regular(12.0)),
                NSForegroundColorAttributeName: Theme.color(type: .SecondaryTextColor)
            ])
            
            self.bioLabel.attributedText = bioAttrString
            
        } else {
            let bioAttrString = NSAttributedString(string: "Bio Not Set", attributes: [
                NSFontAttributeName: Theme.font(type: .Italic(12.0)),
                NSForegroundColorAttributeName: Theme.color(type: .SecondaryTextColor)
                ])
            
            self.bioLabel.attributedText = bioAttrString
        }
        
        ImageCache.sharedImageCache.image(image: Image(userID: model.userID)) {[weak self] success, image in
            self?.avatarImageView.image = image
        }
    }
}
