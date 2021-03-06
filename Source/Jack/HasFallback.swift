import Foundation

internal protocol HasFallback: Equatable {
  static var fallback: Self { get }
}

extension DDLogLevel: HasFallback {
  static var fallback: DDLogLevel {
    return .verbose
  }
}
