// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation
import Async
import PINCache
import ReactiveCocoa

// =======================================================

public enum ImageError: ErrorType {
    case CacheNotFound(String)
    case InvalidURL
    case UnableToLoad
    case UnableToConvert
}

// =======================================================

public class ImageCache: Cache {
    public static let sharedImageCache = ImageCache()
    
    private init() {
        super.init(identifier: "ImageCache")
    }
    
// =======================================================
// MARK: - Helpers
    
    internal func normalize(urlString imageURL: String) -> SignalProducer<String, ImageError> {
        return SignalProducer { observer, disposable in
            observer.sendNext(imageURL)
        }
    }
    
    internal func cachedImage(identifier identifier: String) -> SignalProducer<NSData, ImageError> {
        return SignalProducer { observer, disposable in
            guard let cacheItem = self.item(identifier: identifier),
                let data = cacheItem.item as? NSData else {
                    observer.sendFailed(.CacheNotFound(identifier))
                    return
            }
            
            observer.sendNext(data)
            observer.sendCompleted()
        }
    }
    
    internal func fetchImage(urlString imageURL: String) -> SignalProducer<NSData, ImageError> {
        return SignalProducer { observer, disposable in
            guard let url = NSURL(string: imageURL) else {
                observer.sendFailed(.InvalidURL)
                return
            }
            
            let urlRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60.0)
            let disp = NSURLSession.sharedSession().rac_dataWithRequest(urlRequest)
                .on(failed: { error in
                    observer.sendFailed(ImageError.UnableToLoad)
                })
                .startWithNext { data, response in
                    observer.sendNext(data)
                }
            
            disposable.addDisposable(disp)
        }
    }
    
    internal func writeImage(data data: NSData, forURL url: String) -> SignalProducer<NSData, ImageError> {
        return SignalProducer { observer, disposable in
            let item = CacheableItem(identifier: url, item: data)
            self.saveItem(item: item)
            
            observer.sendNext(data)
            observer.sendCompleted()
        }
    }
    
    public func imageData(urlString urlString: String) -> SignalProducer<NSData, ImageError> {
        return self.normalize(urlString: urlString)
            .observeOn(CoreScheduler.background())
            .flatMap(.Latest, transform: { return self.cachedImage(identifier: $0) })
            .flatMapError { error -> SignalProducer<NSData, ImageError> in
                switch error {
                case .CacheNotFound(let url):
                    return self.fetchImage(urlString: url)
                        .retry(3)
                        .flatMap(.Latest, transform: { return self.writeImage(data: $0, forURL: url) })
                    
                default:
                    return SignalProducer { observer, _ in
                        observer.sendFailed(error)
                    }
                }
        }
    }

// =======================================================
// MARK: - Public Interface
    
    public func imageData(urlString urlString: String, completion: ((success: Bool, imageData: NSData?) -> Void)) {
        self.imageData(urlString: urlString)
            .start { event in
                switch event {
                case .Failed(_):
                    completion(success: false, imageData: nil)
                    
                case .Next(let imageData):
                    completion(success: true, imageData: imageData)
                    
                default:
                    break
                }
            }
    }
    
// =======================================================
// MARK: - Clearing
    
/**
Clears every cached image
*/
    
    public static func clearCache() {
        self.sharedImageCache.deleteAllItems()
    }

/**
Clears every image not used in the last two days
*/
    
    public class func clearOldCacheItems() {
        self.sharedImageCache.deleteOldItems()
    }
}
