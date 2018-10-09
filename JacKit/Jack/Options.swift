import Foundation

import CocoaLumberjack

extension Jack {
  
  public struct Options: OptionSet, HasFallback {
    
    static var fallback: Jack.Options {
      return .default
    }
    
    public let rawValue: Int

    public init(rawValue: Int) {
      self.rawValue = rawValue
    }

    // Primitive cases
    public static let noLevelIcon = Options(rawValue: 1 << 0)
    public static let noLocation = Options(rawValue: 1 << 1)
    public static let noScope = Options(rawValue: 1 << 2)
    
    // Use as less lines as possible
    public static let compact = Options(rawValue: 1 << 3)

    // Default option
    public static let `default`: Options = []
    // Only the message text
    public static let bare: Options = [.noLevelIcon, .noLocation, .noScope]
    // Single line, no locaion line
    public static let short: Options = [.noLocation, .compact]
  }

}
