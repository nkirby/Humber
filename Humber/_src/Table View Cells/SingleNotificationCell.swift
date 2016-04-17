// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

class SingleNotificationCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var repoLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
        self.repoLabel.text = ""
        self.iconImageView.image = nil
    }
    
// =======================================================

    internal func render(model model: GithubNotificationModel) {
        self.backgroundColor = Theme.color(type: .CellBackgroundColor)

        let titleAttrString = NSAttributedString(string: model.title, attributes: [
            NSFontAttributeName: Font.bold(size: 12.0),
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor)
        ])
        
        self.titleLabel.attributedText = titleAttrString
        
        let repoAttrString = NSAttributedString(string: model.repository.fullName, attributes: [
            NSFontAttributeName: Font.regular(size: 12.0),
            NSForegroundColorAttributeName: Theme.color(type: .SecondaryTextColor)
        ])
        
        self.repoLabel.attributedText = repoAttrString
        
        ImageCache.sharedImageCache.image(image: model.type.image()) {[weak self] success, image in
            self?.iconImageView.image = image?.imageWithRenderingMode(.AlwaysTemplate)
            self?.iconImageView.tintColor = Theme.color(type: .SecondaryTextColor)
        }
    }
}
