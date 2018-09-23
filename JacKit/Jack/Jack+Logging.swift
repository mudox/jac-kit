import Foundation

import CocoaLumberjack

// MARK: - Helpers

// fileprivate func _file(_ file: StaticString) -> String {
//  return URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
// }
//
// fileprivate func _fileFunction(_ file: StaticString, _ function: StaticString) -> String {
//  let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
//  return "\(fileName).\(function)"
// }
//
fileprivate func fileLine(_ file: StaticString, _ line: UInt) -> String {
  let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
  return "\(fileName):\(line)"
}

//
// fileprivate func _fileFunctionLine(_ file: StaticString, _ function: StaticString, _ line: UInt) -> String {
//  let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
//  return "\(fileName).\(function):\(line)"
// }

fileprivate func compose(
  _ scope: Jack.Scope,
  _ message: String,
  _ options: Jack.Options,
  _ file: StaticString,
  _: StaticString,
  _ line: UInt
) -> String {
  let location = fileLine(file, line)

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
    return "Jack._compose JSON serialization error: \(error)"
  }
}

// MARK: - Logging

extension Jack {
  private func canLog(flag: DDLogFlag) -> Bool {
    return level.rawValue & flag.rawValue != 0
  }

  public func error(
    _ message: @autoclosure () -> String,
    options: Jack.Options? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if canLog(flag: .error) {
      let message = compose(scope, message(), options ?? self.options, file, function, line)
      DDLogError(message, level: level)
    }
  }

  public func warn(
    _ message: @autoclosure () -> String,
    options: Jack.Options? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if canLog(flag: .warning) {
      let message = compose(scope, message(), options ?? self.options, file, function, line)
      DDLogWarn(message, level: level)
    }
  }

  public func info(
    _ message: @autoclosure () -> String,
    options: Jack.Options? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if canLog(flag: .info) {
      let message = compose(scope, message(), options ?? self.options, file, function, line)
      DDLogInfo(message, level: level)
    }
  }

  public func debug(
    _ message: @autoclosure () -> String,
    options: Jack.Options? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if canLog(flag: .debug) {
      let message = compose(scope, message(), options ?? self.options, file, function, line)
      DDLogDebug(message, level: level)
    }
  }

  public func verbose(
    _ message: @autoclosure () -> String,
    options: Jack.Options? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if canLog(flag: .verbose) {
      let message = compose(scope, message(), options ?? self.options, file, function, line)
      DDLogVerbose(message, level: level)
    }
  }
  
}

// MARK: - Assertion

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
