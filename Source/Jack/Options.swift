import Foundation

import CocoaLumberjack

extension Jack {

  public struct Options: OptionSet, HasFallback {

    public let rawValue: Int

    public init(rawValue: Int) {
      self.rawValue = rawValue
    }

    // MARK: - Primitive Options

    public static let noIcon = Options(rawValue: 1 << 0)
    
    public static let noLocation = Options(rawValue: 1 << 1)
    
    public static let noScope = Options(rawValue: 1 << 2)
    
    /// Use as less lines as possible
    public static let compact = Options(rawValue: 1 << 3)

    // MARK: - Composed Options

    /// Default option - empty option set.
    public static let fallback: Options = []
    
    /// Only the message text
    public static let bare: Options = [.noIcon, .noLocation, .noScope]
    
    /// Single line, no locaion line
    public static let short: Options = [.noLocation, .compact]
  }

}
