// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class SingleIssueCell: UITableViewCell {
    @IBOutlet var issueTitleLabel: UILabel!
    @IBOutlet var repoLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.userImageView.layer.masksToBounds = true
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2.0
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.userImageView.image = nil
        self.repoLabel.text = ""
        self.issueTitleLabel.text = ""
    }
    
// =======================================================

    internal func render(model model: GithubIssueModel) {
        let titleAttrString = NSAttributedString(string: "#\(model.issueNumber) \(model.title)", attributes: [
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor),
            NSFontAttributeName: Theme.font(type: .Bold(12.0))
        ])
        
        self.issueTitleLabel.attributedText = titleAttrString
        
        if let fullName = model.repository?.fullName {
            let repoAttrString = NSAttributedString(string: fullName, attributes: [
                NSForegroundColorAttributeName: Theme.color(type: .SecondaryTextColor),
                NSFontAttributeName: Theme.font(type: .Regular(12.0))
            ])
            
            self.repoLabel.attributedText = repoAttrString
            
        } else {
            let repoAttrString = NSAttributedString(string: "Unknown", attributes: [
                NSForegroundColorAttributeName: Theme.color(type: .SecondaryTextColor),
                NSFontAttributeName: Theme.font(type: .Italic(12.0))
            ])
            
            self.repoLabel.attributedText = repoAttrString
        }
        
        if let userID = model.user?.userID {
            ImageCache.sharedImageCache.image(image: Image(userID: userID)) {[weak self] success, image in
                self?.userImageView.image = image
            }
        }
    }
}
