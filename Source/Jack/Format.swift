import Foundation

import CocoaLumberjack

public extension Jack {

  struct Format: OptionSet, HasFallback {

    public let rawValue: Int

    public init(rawValue: Int) {
      self.rawValue = rawValue
    }

    // MARK: - Primitive Options

    public static let noIcon = Format(rawValue: 1 << 0)

    public static let noLocation = Format(rawValue: 1 << 1)

    public static let noScope = Format(rawValue: 1 << 2)

    /// Use as less lines as possible
    public static let compact = Format(rawValue: 1 << 3)

    // MARK: - Composed Options

    /// Default option - empty option set.
    public static let fallback: Format = []

    /// Only the message text
    public static let bare: Format = [.noIcon, .noLocation, .noScope]

    /// Single line, no locaion line
    public static let short: Format = [.noLocation, .compact]
  }

}
