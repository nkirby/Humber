// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import UIKit

internal final class ShareURLProvider: UIActivityItemProvider {
    private let url: NSURL
    
    internal init(url: NSURL) {
        self.url = url
        
        super.init(placeholderItem: self.url)
    }
    
    override func item() -> AnyObject {
        guard let activityType = self.activityType else {
            return self.url
        }
        
        switch activityType {
        case UIActivityTypeMail:
            return ""
            
        default:
            return self.url
        }
    }
}

