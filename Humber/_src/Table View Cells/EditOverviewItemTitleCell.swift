// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

internal protocol EditOverviewTitleDelegate: class {
    var tapGestureView: UIView { get }
    func didUpdateTitle(title title: String)
}

// =======================================================

class EditOverviewItemTitleCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    private var tapGesture: UITapGestureRecognizer?
    private weak var delegate: EditOverviewTitleDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [
            NSFontAttributeName: Theme.font(type: .Regular(12.0)),
            NSForegroundColorAttributeName: Theme.color(type: .DisabledTextColor)
        ])
        
        self.textField.font = Theme.font(type: .Regular(12.0))
        self.textField.delegate = self
        
        self.textField.rac_textSignal().subscribeNext {[weak self] obj in
            if let text = obj as? String {
                self?.delegate?.didUpdateTitle(title: text)
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let tapGesture = self.tapGesture {
            tapGesture.view?.removeGestureRecognizer(tapGesture)
            self.tapGesture = nil
        }
        
        self.delegate = nil
        self.textField.text = ""
    }
    
// =======================================================

    internal func render(model model: GithubOverviewItemModel, delegate: EditOverviewTitleDelegate) {
        self.delegate = delegate
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditOverviewItemTitleCell.didTapView))
        delegate.tapGestureView.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        self.tapGesture = tapGesture
        
        self.textField.text = model.title
    }
    
    @objc private func didTapView() {
        self.textField.resignFirstResponder()
    }
    
// =======================================================
// MARK: - Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
