// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa

// =======================================================

public final class CoreScheduler: NSObject {
    private static let backgroundSchedulerName = "com.projectspong.RACScheduler.Background"
    
    public static func background() -> QueueScheduler {
        return QueueScheduler(qos: QOS_CLASS_BACKGROUND, name: self.backgroundSchedulerName)
    }
    
    public static func main() -> UIScheduler {
        return UIScheduler()
    }
}
