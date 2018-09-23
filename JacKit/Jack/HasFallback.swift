import Foundation

import CocoaLumberjack

internal protocol HasFallback: Equatable {
  static var fallback: Self { get }
}

extension DDLogLevel: HasFallback {
  static var fallback: DDLogLevel {
    return .verbose
  }
}

extension Jack.Options : HasFallback {
  static var fallback: Jack.Options {
    return .default
  }
}
