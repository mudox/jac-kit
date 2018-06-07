import Foundation
import CocoaLumberjack

fileprivate enum Formatter {

  fileprivate static func fileFunction(_ file: StaticString, _ function: StaticString) -> String {
    let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
    return "\(fileName).\(function)"
  }

  fileprivate static func fileFunctionLine(_ file: StaticString, _ function: StaticString, _ line: UInt) -> String {
    let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
    return "\(fileName).\(function):\(line)"
  }

  fileprivate static func compose(
    _ scope: String,
    _ message: String,
    _ file: StaticString,
    _ function: StaticString,
    _ line: UInt
  ) -> String {

    let location = Formatter.fileFunctionLine(file, function, line)
    let prefix = "\(scope) @ \(location)"

    assert(!prefix.contains("\u{0B}"), """
      logging prefix should not contain "\u{0B}" character, which is used to delimit \
      prefix and message.
      """)

    return "\(prefix)\u{0B}\(message)"
  }

}

extension Jack {

  // MARK: Convenient Initialiazers

  public static func usingLocalFileScope(
    _ file: StaticString = #file,
    _ function: StaticString = #function,
    _ line: UInt = #line
  ) -> Jack {
    return Jack(scope: Formatter.fileFunction(file, function))
  }

  public static func usingAppScope(
    _ file: StaticString = #file,
    _ function: StaticString = #function,
    _ line: UInt = #line
  ) -> Jack {
    return Jack(scope: ProcessInfo.processInfo.processName)
  }


  private func _canLog(flag: DDLogFlag) -> Bool {
    return level.rawValue & flag.rawValue != 0
  }

  // MARK: Logging Methods

  public func error(
    _ message: @autoclosure () -> String,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .error) {
      let message = Formatter.compose(scope.string, message(), file, function, line)
      DDLogError(message, level: level)
    }
  }

  public func warn(
    _ message: @autoclosure () -> String,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .warning) {
      let message = Formatter.compose(scope.string, message(), file, function, line)
      DDLogWarn(message, level: level)
    }
  }

  public func info(
    _ message: @autoclosure () -> String,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .info) {
      let message = Formatter.compose(scope.string, message(), file, function, line)
      DDLogInfo(message, level: level)
    }
  }

  public func debug(
    _ message: @autoclosure () -> String,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .debug) {
      let message = Formatter.compose(scope.string, message(), file, function, line)
      DDLogDebug(message, level: level)
    }
  }

  public func verbose(
    _ message: @autoclosure () -> String,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .verbose) {
      let message = Formatter.compose(scope.string, message(), file, function, line)
      DDLogVerbose(message, level: level)
    }
  }
}

extension Jack {
  
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

  public static func assert(
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
  public static func failure(
    _ message: String,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    assert(false, message, file: file, line: line)
  }
}
