// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation
import JLRoutes
import Async

// =======================================================

public class Router: NSObject {
    public static var permissions = [RoutePermission]()
    public static var scheme = Config.routeScheme
    
    private static var currentSource = RouteSource.UserInitiated
    private static let router = JLRoutes()
    
// =======================================================
// MARK: - Opening URLs
    
    public class func handleOpenURL(url: NSURL) -> Bool {
        if url.scheme == self.scheme {
            self.route(url: url, source: RouteSource.LaunchTarget)
            return true
        }
        
        return false
    }

// =======================================================
// MARK: - Helpers
    
    private static func log(string: String) {
        if Config.routerLogging {
            print(string)
        }
    }
    
    public static func urlFromPath(path: String) -> NSURL? {
        let scheme = self.scheme
        return NSURL(string: "\(scheme)://\(path)")
    }

// =======================================================
// MARK: - Routing
    
    public static func route(path path: String, source: RouteSource) {
        let url = self.urlFromPath(path)
        self.route(url: url, source: source)
    }
    
    public static func route(url url: NSURL?, source: RouteSource) {
        guard let urlObj = url else {
            return
        }
        
        Async.main {
            self.log("ROUTE: \(urlObj.absoluteString)")
            self.currentSource = source
            self.router.routeURL(urlObj)
        }
    }
    
// =======================================================
// MARK: - Route Manipulation
    
    public static func addRoute(path: String, source: RouteSource, permissions: [RoutePermission], completion: ((info: [NSObject: AnyObject]) -> Bool)) {
        self.router.addRoute(path) { info -> Bool in
            if !source.contains(self.currentSource) {
                return false
            }
            
            for permission in permissions {
                if !self.permissions.contains(permission) {
                    self.log("Router: Missing Permission \(permission)")
                    return false
                }
            }
            
            return completion(info: info ?? [:])
        }
    }
}
