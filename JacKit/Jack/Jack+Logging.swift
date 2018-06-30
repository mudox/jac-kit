import Foundation
import CocoaLumberjack

extension Jack {

  public struct FormattingOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
      self.rawValue = rawValue
    }

    // Primitive cases
    public static let noLevelIcon = FormattingOptions(rawValue: 1 << 0)
    public static let noLocation = FormattingOptions(rawValue: 1 << 1)
    public static let noScope = FormattingOptions(rawValue: 1 << 2)
    public static let compact = FormattingOptions(rawValue: 1 << 3)

    // Derived cases
    public static let `default`: FormattingOptions = []
    public static let messageOnly: FormattingOptions = [.noLevelIcon, .noLocation, .noScope]
  }

}

fileprivate enum Formatter {

  static func file(_ file: StaticString) -> String {
    return URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
  }

  static func fileFunction(_ file: StaticString, _ function: StaticString) -> String {
    let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
    return "\(fileName).\(function)"
  }

  static func fileLine(_ file: StaticString, _ line: UInt) -> String {
    let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
    return "\(fileName):\(line)"
  }

  static func fileFunctionLine(_ file: StaticString, _ function: StaticString, _ line: UInt) -> String {
    let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
    return "\(fileName).\(function):\(line)"
  }

  static func compose(
    _ scope: String,
    _ message: String,
    _ options: Jack.FormattingOptions,
    _ file: StaticString,
    _ function: StaticString,
    _ line: UInt
  ) -> String {
    let location = Formatter.fileLine(file, line)
    let prefix = "\(scope) ·· \(location)"

    assert(!prefix.contains("\u{0B}"), """
      logging prefix should not contain "\u{0B}" character, which is used to delimit \
      prefix and message.
      """)

    let jsonObject: [String: Any] = [
      "scope": scope,
      "location": location,
      "message": message,
      "options": options.rawValue,
    ]

    do {
      let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
      guard let jsonString = String(data: jsonData, encoding: .utf8) else {
        return "Jack.Formatter json string init error"
      }
      return jsonString
    } catch {
      return "Jack.Formatter json serialization error: \(error)"
    }
  }

}

extension Jack {

  // MARK: Convenient Initialiazers

  private func _canLog(flag: DDLogFlag) -> Bool {
    return level.rawValue & flag.rawValue != 0
  }

  // MARK: Logging Methods

  public func error(
    _ message: @autoclosure () -> String,
    options: Jack.FormattingOptions = .default,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .error) {
      let message = Formatter.compose(scope.string, message(), options, file, function, line)
      DDLogError(message, level: level)
    }
  }

  public func warn(
    _ message: @autoclosure () -> String,
    options: Jack.FormattingOptions = .default,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .warning) {
      let message = Formatter.compose(scope.string, message(), options, file, function, line)
      DDLogWarn(message, level: level)
    }
  }

  public func info(
    _ message: @autoclosure () -> String,
    options: Jack.FormattingOptions = .default,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .info) {
      let message = Formatter.compose(scope.string, message(), options, file, function, line)
      DDLogInfo(message, level: level)
    }
  }

  public func debug(
    _ message: @autoclosure () -> String,
    options: Jack.FormattingOptions = .default,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .debug) {
      let message = Formatter.compose(scope.string, message(), options, file, function, line)
      DDLogDebug(message, level: level)
    }
  }

  public func verbose(
    _ message: @autoclosure () -> String,
    options: Jack.FormattingOptions = .default,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .verbose) {
      let message = Formatter.compose(scope.string, message(), options, file, function, line)
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
