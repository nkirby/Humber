// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import HMCore

// =======================================================

internal struct AccountIconAndCountViewModel {
    internal let title: String
    internal let icon: Image
    internal let count: Int
    
    internal init(title: String, icon: Image, count: Int) {
        self.title = title
        self.icon = icon
        self.count = count
    }
}

// =======================================================

class AccountIconAndCountCell: UITableViewCell {
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.iconImageView.image = nil
        self.titleLabel.text = ""
        self.countLabel.text = ""
    }
    
// =======================================================

    internal func render(model model: AccountIconAndCountViewModel) {
        let titleAttrString = NSAttributedString(string: model.title, attributes: [
            NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor),
            NSFontAttributeName: Theme.font(type: .Regular(14.0))
        ])
        
        self.titleLabel.attributedText = titleAttrString

        let countAttrString = NSAttributedString(string: "\(model.count)", attributes: [
            NSForegroundColorAttributeName: Theme.color(type: .TintColor),
            NSFontAttributeName: Theme.font(type: .Bold(11.0))
        ])
        
        self.countLabel.attributedText = countAttrString
        
        ImageCache.sharedImageCache.image(image: model.icon) {[weak self] success, image in
            self?.iconImageView.image = image
        }
        
    }
}
