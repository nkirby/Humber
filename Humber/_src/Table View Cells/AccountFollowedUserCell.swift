// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class AccountFollowedUserCell: UITableViewCell {
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconImageView.layer.masksToBounds = true
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width / 2.0
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.iconImageView.image = nil
        self.usernameLabel.text = ""
    }
    
// =======================================================

    internal func render(model model: GithubUserModel) {
        self.backgroundColor = Theme.color(type: .CellBackgroundColor)

        let attrString = NSAttributedString(string: model.login, attributes: [
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor),
            NSFontAttributeName: Theme.font(type: .Bold(12.0))
        ])
        
        self.usernameLabel.attributedText = attrString
        
        ImageCache.sharedImageCache.image(image: Image(userID: model.userID)) {[weak self] success, image in
            self?.iconImageView.image = image
        }
    }
}
