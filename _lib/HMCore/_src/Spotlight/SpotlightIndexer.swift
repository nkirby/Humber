// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation
import CoreSpotlight
import MobileCoreServices

// =======================================================

public struct SpotlightIndexableItem {
    public let title: String
    public let contentDescription: String
    public let identifier: String
    public let domain: String
    
    public init(title: String, contentDescription: String, identifier: String, domain: String) {
        self.title = title
        self.contentDescription = contentDescription
        self.identifier = identifier
        self.domain = domain
    }
}

// =======================================================

public protocol SpotlightIndexProviding {
    func indexItem(item item: SpotlightIndexableItem)
    func indexItems(items items: [SpotlightIndexableItem])
}

public class SpotlightIndexer: NSObject, SpotlightIndexProviding {
    public func indexItem(item item: SpotlightIndexableItem) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = item.title
        attributeSet.contentDescription = item.contentDescription
        
        let item = CSSearchableItem(uniqueIdentifier: item.identifier, domainIdentifier: item.domain, attributeSet: attributeSet)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { error in
            if let err = error {
                print("error: \(err)")
            }
        }

    }
    
    public func indexItems(items items: [SpotlightIndexableItem]) {
        for item in items {
            self.indexItem(item: item)
        }
    }
}
