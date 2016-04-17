// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import SnapKit

import HMCore

// =======================================================

internal class PlainTableSectionHeaderView: UIView {
    private let titleLabel = UILabel(frame: CGRect.zero)
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setupHeaderView() {
        self.addSubview(self.titleLabel)
    
        self.titleLabel.snp_makeConstraints { make in
            make.margins.equalTo(self).offset(UIEdgeInsets(top: 4, left: 16.0, bottom: 0, right: -18.0))
        }
    }
    
// =======================================================
// MARK: - 
    
    internal func render(text text: String) {
        let attrString = NSAttributedString(string: text.uppercaseString, attributes: [
            NSForegroundColorAttributeName: Theme.color(type: .TintColor), // UIColor(red: 75.0/255.0, green: 133.0/255.0, blue: 17.0/255.0, alpha: 1.0),
            NSFontAttributeName: Theme.font(type: .Regular(12.0))
        ])
        
        self.titleLabel.attributedText = attrString
    }
}
