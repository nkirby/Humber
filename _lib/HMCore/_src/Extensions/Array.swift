// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

extension Array {
    public func get(index: Int) -> Element? {
        if index >= 0 && index < self.count {
            return self[index]
        }
        
        return nil
    }

    public func get(range: Range<Int>) -> [Element] {
        if range.startIndex < 0 {
            return []
        }
        
        if range.startIndex + range.endIndex > self.count {
            return Array(self[range.startIndex..<self.count])
        }
        
        return Array(self[range])
    }
}
