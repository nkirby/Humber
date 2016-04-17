//
//  SingleNotificationCell.swift
//  Humber
//
//  Created by Nathaniel Kirby on 4/16/16.
//  Copyright © 2016 projectspong. All rights reserved.
//

import UIKit

import HMCore
import HMGithub

class SingleNotificationCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var repoLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    internal func render(model model: GithubNotificationModel) {
        let titleAttrString = NSAttributedString(string: model.title, attributes: [
            NSFontAttributeName: Font.bold(size: 12.0),
            NSForegroundColorAttributeName: UIColor(white: 0.05, alpha: 1.0)
        ])
        
        self.titleLabel.attributedText = titleAttrString
        
        let repoAttrString = NSAttributedString(string: model.repository.fullName, attributes: [
            NSFontAttributeName: Font.regular(size: 12.0),
            NSForegroundColorAttributeName: UIColor(white: 0.25, alpha: 1.0)
        ])
        
        self.repoLabel.attributedText = repoAttrString
        
        ImageCache.sharedImageCache.image(image: model.type.image()) {[weak self] success, image in
            self?.iconImageView.image = image?.imageWithRenderingMode(.AlwaysTemplate)
            self?.iconImageView.tintColor = UIColor(white: 0.75, alpha: 1.0)
        }
    }
}
