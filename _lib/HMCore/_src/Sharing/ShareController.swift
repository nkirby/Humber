// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import UIKit

// =======================================================

public protocol ShareProviding {
    func share(url url: String) -> UIActivityViewController?
}

public enum ShareTarget {
    case BarButtonItem(UIBarButtonItem)
    case View(UIView)
}


public class ShareController: NSObject, ShareProviding {
    public func share(url urlString: String) -> UIActivityViewController? {
        guard let url = NSURL(string: urlString) else {
            print("invalid url?")
            return nil
        }
        
        let activityItemProviders: [AnyObject] = [ShareURLProvider(url: url)]

        let activityVC = UIActivityViewController(activityItems: activityItemProviders, applicationActivities: [])
        return activityVC
    }
}
