// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import SnapKit

import HMCore
import HMGithub

// =======================================================

class OverviewDividerCollectionCell: UICollectionViewCell {
    private let divider = UIView(frame: CGRect.zero)
    private let label = UILabel(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupDividerCollectionCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupDividerCollectionCell()
    }
    
    private func setupDividerCollectionCell() {
        self.contentView.addSubview(self.divider)
        self.contentView.addSubview(self.label)
        
        self.divider.snp_makeConstraints { make in
            make.left.equalTo(10.0)
            make.right.equalTo(-10.0)
            make.bottom.equalTo(0.0)
            make.height.equalTo(1.0)
        }
        
        self.label.snp_makeConstraints { make in
            make.left.equalTo(10.0)
            make.right.equalTo(-10.0)
            make.bottom.equalTo(-8.0)
        }
    }
    
    internal func render(model model: GithubOverviewItemModel) {
        let titleAttrString = NSAttributedString(string: model.title, attributes: [
            NSFontAttributeName: Theme.font(type: .Regular(14.0)),
            NSForegroundColorAttributeName: Theme.color(type: .TintColor)
        ])
        
        self.label.attributedText = titleAttrString
        self.divider.backgroundColor = Theme.color(type: .DisabledTextColor)
    }
}
