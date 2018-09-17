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
    public static let bare: FormattingOptions = [.noLevelIcon, .noLocation, .noScope]
    public static let short: FormattingOptions = [.noLocation, .compact]
  }

  public static var formattingOptions: FormattingOptions = []
}

// MARK: - Message Composing Helpers

// fileprivate func _file(_ file: StaticString) -> String {
//  return URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
// }
//
// fileprivate func _fileFunction(_ file: StaticString, _ function: StaticString) -> String {
//  let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
//  return "\(fileName).\(function)"
// }
//
fileprivate func _fileLine(_ file: StaticString, _ line: UInt) -> String {
  let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
  return "\(fileName):\(line)"
}

//
// fileprivate func _fileFunctionLine(_ file: StaticString, _ function: StaticString, _ line: UInt) -> String {
//  let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
//  return "\(fileName).\(function):\(line)"
// }

fileprivate func _compose(
  _ scope: Jack.Scope,
  _ message: String,
  _ options: Jack.FormattingOptions,
  _ file: StaticString,
  _: StaticString,
  _ line: UInt
) -> String {
  let location = _fileLine(file, line)

  let scopeText: String
  switch scope.kind {
  case .file:
    scopeText = "[F] \(scope.string)"
  case .normal:
    scopeText = scope.string
  }

  let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent

  let jsonObject: [String: Any] = [
    "scope": scopeText,
    "location": location, // TODO: check if jacsrv need this field
    "filename": fileName,
    "lineno": line,
    "message": message,
    "options": options.rawValue,
  ]

  do {
    let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
    guard let jsonString = String(data: jsonData, encoding: .utf8) else {
      return "Jack.Formatter json string init error"
    }
    return jsonString
  } catch {
    return "Jack.Formatter json serialization error: \(error)"
  }
}

// MARK: - Logging Methods

extension Jack {
  private func _canLog(flag: DDLogFlag) -> Bool {
    return level.rawValue & flag.rawValue != 0
  }

  public func error(
    _ message: @autoclosure () -> String,
    options: Jack.FormattingOptions = Jack.formattingOptions,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .error) {
      let message = _compose(scope, message(), options, file, function, line)
      DDLogError(message, level: level)
    }
  }

  public func warn(
    _ message: @autoclosure () -> String,
    options: Jack.FormattingOptions = Jack.formattingOptions,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .warning) {
      let message = _compose(scope, message(), options, file, function, line)
      DDLogWarn(message, level: level)
    }
  }

  public func info(
    _ message: @autoclosure () -> String,
    options: Jack.FormattingOptions = Jack.formattingOptions,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .info) {
      let message = _compose(scope, message(), options, file, function, line)
      DDLogInfo(message, level: level)
    }
  }

  public func debug(
    _ message: @autoclosure () -> String,
    options: Jack.FormattingOptions = Jack.formattingOptions,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .debug) {
      let message = _compose(scope, message(), options, file, function, line)
      DDLogDebug(message, level: level)
    }
  }

  public func verbose(
    _ message: @autoclosure () -> String,
    options: Jack.FormattingOptions = Jack.formattingOptions,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .verbose) {
      let message = _compose(scope, message(), options, file, function, line)
      DDLogVerbose(message, level: level)
    }
  }
}

// MARK: - Assertion methods

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
    function _: StaticString = #function,
    line: UInt = #line
  ) {
    assert(false, message, file: file, line: line)
  }
}
