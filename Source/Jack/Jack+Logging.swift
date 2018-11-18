import Foundation

import CocoaLumberjack

// MARK: - Logging

extension Jack {
  private func canLog(flag: DDLogFlag) -> Bool {
    return level.rawValue & flag.rawValue != 0
  }

  public func error(
    _ message: @autoclosure () -> String,
    format: Jack.Format? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if canLog(flag: .error) {
      let package = Package(
        scope: scope,
        message: message(),
        format: format ?? self.format,
        file: file, function: function, line: line
      )
      DDLogError(package.messageString, level: level)
    }
  }

  public func warn(
    _ message: @autoclosure () -> String,
    format: Jack.Format? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if canLog(flag: .warning) {
      let package = Package(
        scope: scope,
        message: message(),
        format: format ?? self.format,
        file: file, function: function, line: line
      )
      DDLogWarn(package.messageString, level: level)
    }
  }

  public func info(
    _ message: @autoclosure () -> String,
    format: Jack.Format? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if canLog(flag: .info) {
      let package = Package(
        scope: scope,
        message: message(),
        format: format ?? self.format,
        file: file, function: function, line: line
      )
      DDLogInfo(package.messageString, level: level)
    }
  }

  public func debug(
    _ message: @autoclosure () -> String,
    format: Jack.Format? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if canLog(flag: .debug) {
      let package = Package(
        scope: scope,
        message: message(),
        format: format ?? self.format,
        file: file, function: function, line: line
      )
      DDLogDebug(package.messageString, level: level)
    }
  }

  public func verbose(
    _ message: @autoclosure () -> String,
    format: Jack.Format? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if canLog(flag: .verbose) {
      let package = Package(
        scope: scope,
        message: message(),
        format: format ?? self.format,
        file: file, function: function, line: line
      )
      DDLogVerbose(package.messageString, level: level)
    }
  }

}

// MARK: - Assertion

public extension Jack {

  /// JacKit' version of `rxFatalError()`.
  /// It `falalError()` in debug mode, while logs a warnning message
  /// in release mode.
  /// Unlike `assert`, the expression is always evaluated.
  ///
  /// - Parameters:
  ///   - valid: The expression to be tested.
  ///   - message: Failure message.
  ///   - file: File name which is autolmatically captured.
  ///   - function: Function name which automatically capture.
  ///   - line: Line number which is automatically captured.
  static func assert(
    _ valid: Bool,
    _ message: String,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if !valid {
      #if DEBUG
        fatalError(message, file: file, line: line)
      #else
        warn(message, file: file, function: function)
      #endif
    }
  }

  /// JacKit' version of `assertionFailure()`.
  /// It `falalError()` in debug mode while logs a warnning message in
  /// release mode.
  ///
  /// - Parameters:
  ///   - message: Failure message.
  ///   - file: File name which is autolmatically captured.
  ///   - function: Function name which automatically capture.
  ///   - line: Line number which is automatically captured.
  static func failure(
    _ message: String,
    file: StaticString = #file,
    function _: StaticString = #function,
    line: UInt = #line
  ) {
    assert(false, message, file: file, line: line)
  }

}
