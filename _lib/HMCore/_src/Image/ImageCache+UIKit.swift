// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

#if os(iOS)
import UIKit

extension ImageCache {
    public func image(image image: Image, completion: ((success: Bool, image: UIImage?) -> Void)) {
        switch image.source {
        case .Local(let name):
            if let image = UIImage(named: name) {
                completion(success: true, image: image)
            } else {
                completion(success: false, image: nil)
            }
            
        case .Remote(let urlString):
            self.imageData(urlString: urlString)
                .observeOn(CoreScheduler.main())
                .start { event in
                    switch event {
                    case .Next(let imageData):
                        if let image = UIImage(data: imageData) {
                            completion(success: true, image: image)
                        } else {
                            completion(success: false, image: nil)
                        }
                        
                    case .Failed(_):
                        completion(success: false, image: nil)
                        
                    default:
                        break
                    }
                }
        }
    }
}

#endif

