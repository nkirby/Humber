// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit
import Async
import SnapKit

import HMCore
import HMGithub

// =======================================================

class OverviewItemSingleStatViewController: UIViewController {
    internal var itemModel: GithubOverviewItemModel?
    
    private let countLabel = UILabel(frame: CGRect.zero)
    private let titleLabel = UILabel(frame: CGRect.zero)
    private let descriptionLabel = UILabel(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSubviews()
        self.fetch()
        self.sync()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupSubviews() {
        self.view.addSubview(self.countLabel)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.descriptionLabel)
        
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.clipsToBounds = true
        self.descriptionLabel.numberOfLines = 0
        
        self.descriptionLabel.snp_makeConstraints { make in
            make.width.equalTo(self.view).offset(-20.0)
            make.centerX.equalTo(0)
            make.bottom.equalTo(-20.0)
        }

        self.titleLabel.snp_makeConstraints { make in
            make.width.equalTo(self.view).offset(-20.0)
            make.centerX.equalTo(0)
            make.bottom.equalTo(self.descriptionLabel.snp_top).offset(-8.0)
        }

        self.countLabel.snp_makeConstraints { make in
            make.width.equalTo(self.view)
            make.centerX.equalTo(0)
            make.top.equalTo(20.0)
        }
    }
    
    private func fetch() {
        guard let model = self.itemModel else {
            return
        }
        
        let centerParagraphStyle = NSMutableParagraphStyle()
        centerParagraphStyle.alignment = NSTextAlignment.Center
        
        Async.main {
            self.titleLabel.attributedText = NSAttributedString(string: model.title, attributes: [
                NSFontAttributeName: Theme.font(type: .Bold(11.0)),
                NSParagraphStyleAttributeName: centerParagraphStyle,
                NSForegroundColorAttributeName: Theme.color(type: .PrimaryTextColor)
            ])
            
            self.descriptionLabel.attributedText = NSAttributedString(string: "\(model.action): \(model.repoOwner)/\(model.repoName)", attributes: [
                NSFontAttributeName: Theme.font(type: .Regular(10.0)),
                NSParagraphStyleAttributeName: centerParagraphStyle,
                NSForegroundColorAttributeName: Theme.color(type: .SecondaryTextColor)
            ])
            
            self.countLabel.attributedText = NSAttributedString(string: "\(model.value)", attributes: [
                NSFontAttributeName: Theme.font(type: .Bold(44.0)),
                NSParagraphStyleAttributeName: centerParagraphStyle,
                NSForegroundColorAttributeName: Theme.color(type: .TintColor)
            ])
        }
    }

    internal func sync() {
        guard let model = self.itemModel else {
            return
        }
        
        ServiceController.component(GithubOverviewSyncProviding.self)?.syncOverviewItem(itemID: model.itemID).startWithNext {
            if let obj = ServiceController.component(GithubOverviewDataProviding.self)?.overviewItem(itemID: model.itemID) {
                self.itemModel = obj
            }
            
            self.fetch()
        }
    }
}
