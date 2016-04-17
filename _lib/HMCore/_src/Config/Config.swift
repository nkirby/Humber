// =======================================================
// DevKit: Core
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

private struct Defaults {
    static let useKeychainAppGroup = true
    static let routerLogging = true
    static let logLevel = 5
    static let routeScheme = ""
}

// =======================================================

public final class Config: NSObject {
    private static var _config: [String: AnyObject]?
    private static let _shared = Config()

// =======================================================
// MARK: - Init, etc...

    private override init() {
        super.init()
    }

// =======================================================
// MARK: - Loader

    public static func loadConfig(filename filename: String, inBundle bundle: NSBundle = Bundle.mainBundle()) {
        guard let path = bundle.pathForResource(filename, ofType: "json") else {
            print("Humber: Invalid Config Filename.")
            return
        }

        self.loadConfig(jsonPath: path)
    }

    public static func loadConfig(jsonPath path: String) {
        guard let data = NSData(contentsOfFile: path),
            let dict = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject] else {
                print("Humber: Invalid Config.")
                return
        }

        self._config = dict
        
        let app = AppInfo(appIdentifier: "Humber")
        AppInfo.currentApp = app
    }

    internal static func reset() {        
        self._config = nil
    }

// =======================================================
// MARK: - Helper

    private static func value<T>(key: String, defaultValue: T) -> T {
        return self._config?[key] as? T ?? defaultValue
    }

    public static func value<T>(key: String) -> T? {
        return self._config?[key] as? T
    }

// =======================================================
// MARK: - Values

    public static var usekeychainAppGroup: Bool {
        return self.value("keychain_app_group", defaultValue: Defaults.useKeychainAppGroup)
    }
    
    public static var routerLogging: Bool {
        return self.value("router_logging", defaultValue: Defaults.routerLogging)
    }
    
    public static var logLevel: Int {
        return self.value("log_level", defaultValue: Defaults.logLevel)
    }
    
    public static var routeScheme: String {
        return self.value("route_scheme", defaultValue: Defaults.routeScheme)
    }
    
// =======================================================
// MARK: - Simulator

    public static func isSimulator() -> Bool {
#if (arch(i386) || arch(x86_64)) && os(iOS)
        return true
#else
        return false
#endif
    }
}
