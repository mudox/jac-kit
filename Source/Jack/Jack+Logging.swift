import Foundation

import CocoaLumberjack


extension Jack {
  
  private static var forceFullFormatForErrorLogging = true
  
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
      let errorFormat: Format
      if Jack.forceFullFormatForErrorLogging {
        errorFormat = []
      } else {
        errorFormat = format ?? self.format
      }
      
      let package = Package(
        scope: scope,
        message: message(),
        format: errorFormat,
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
  ///
  /// It `falalError()` in debug mode, while logs a warnning message
  /// in release mode.
  ///
  /// - Note: Unlike `Swift.assert`, the expression is always evaluated.
  ///
  /// - Parameters:
  ///   - valid: The expression to be tested.
  ///   - message: Failure message.
  ///   - file: File name which is autolmatically captured.
  ///   - function: Function name which automatically capture.
  ///   - line: Line number which is automatically captured.
  func assert(
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
        error(message, format: [], file: file, function: function)
      #endif
    }
  }

  /// JacKit' version of `assertionFailure()`.
  ///
  /// It `falalError()` in debug mode while logs a warnning message in
  /// release mode.
  ///
  /// - Parameters:
  ///   - message: Failure message.
  ///   - file: File name which is autolmatically captured.
  ///   - function: Function name which automatically capture.
  ///   - line: Line number which is automatically captured.
  func failure(
    _ message: String,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    assert(false, message, file: file, function: function, line: line)
  }

  func assertBackgroundThread(
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if Thread.isMainThread {
      failure(
        "this method is time consuming, should run on background thread",
        file: file, function: function, line: line
      )
    }
  }

  func assertMainThread(
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if !Thread.isMainThread {
      failure(
        "this method should be run on main thread",
        file: file, function: function, line: line
      )
    }
  }

}
