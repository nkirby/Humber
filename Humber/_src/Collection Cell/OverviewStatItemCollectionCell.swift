// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import SnapKit

import HMCore
import HMGithub

// =======================================================

class OverviewStatItemCollectionCell: UICollectionViewCell {
    private let containerView = UIView(frame: CGRect.zero)
    private weak var statViewController: OverviewItemSingleStatViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupStatItemCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupStatItemCell()
    }
    
    private func setupStatItemCell() {
        self.contentView.addSubview(self.containerView)
        
        self.containerView.snp_makeConstraints { make in
            make.edges.equalTo(self.contentView).offset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10))
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        let subviews = self.containerView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        self.statViewController = nil
    }
    
    internal func render(viewController viewController: OverviewItemSingleStatViewController) {
        self.statViewController = viewController
        
        viewController.view.frame = self.containerView.bounds
        self.containerView.addSubview(viewController.view)
    }
}
