// =======================================================
// Humber
// Nathaniel Kirby
// =======================================================

import UIKit

import HMCore
import HMGithub

// =======================================================

internal final class ApplicationSetupController: NSObject {
    internal static func setupApplication() {
#if HUMBER_DEBUG
        Config.loadConfig(filename: "debug", inBundle: Bundle.mainBundle())
#else
        Config.loadConfig(filename: "release", inBundle: Bundle.mainBundle())
#endif
        
        self.setupServices()
    }
    
    private static func setupServices() {
        ServiceController.sharedController.setup { container in
            container.registerBuilder { context in
                return GithubLoginAPI()
            }
            
            container.registerBuilder { context in
                return GithubAPI(context: context)
            }
            
            container.registerBuilder { context in
                return DataController(context: context, realmIdentifier: "humber_user_data")
            }
            
            container.registerBuilder { context in
                return SyncController(context: context)
            }
            
            container.registerBuilder { context in
                return SpotlightIndexer()
            }
        }
    }
}
