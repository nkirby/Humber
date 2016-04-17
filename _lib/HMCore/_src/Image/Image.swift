// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

public enum ImageSource {
    case Local(String)
    case Remote(String)
}

public enum ImageType {
    case JPEG
    case PNG
    case GIF
}

// =======================================================

public struct Image {
    public let source: ImageSource
    public let type: ImageType
    
    public init(source: ImageSource, type: ImageType) {
        self.source = source
        self.type = type
    }
    
    public init(userID: String) {
        self.source = .Remote("https://avatars3.githubusercontent.com/u/\(userID)?v=3")
        self.type = .JPEG
    }
}
