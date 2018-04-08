//
//  Mudox.swift
//  YiDaIOSSwiftPractices
//
//  Created by Mudox on 9/9/16.
//  Copyright © 2016 Mudox. All rights reserved.
//

import Foundation
import CocoaLumberjack

// MARK: - File local level management
extension Jack {

  private static var _fileLocalLevels = [String: DDLogLevel]()

  private static func _register(level: DDLogLevel, file: StaticString = #file) {
    _fileLocalLevels[file.description] = level
  }

  fileprivate static func _level(of file: StaticString) -> DDLogLevel {
    if let level = _fileLocalLevels[file.description] {
      return level
    } else {
      return defaultDebugLevel
    }
  }
  
  /**
   In the start of each file that you want to set a per file debug severity level for, add following line:
   `fileprivate let jack = Jack.with(levelOfThisFile: .warning)`

   - parameter level:    DDLogLevel
   - parameter fileName: Auto passed by syntax #file. Ususally DO NOT specify it explicitly

   - returns: Jack.Type for compiler's happiness
   */
  public static func with(levelOfThisFile level: DDLogLevel, _ file: StaticString = #file) -> Jack.Type {
    _register(level: level, file: file)
    return Jack.self
  }

  public static func with(fileLocalLevel level: DDLogLevel, _ file: StaticString = #file) -> Jack.Type {
    _register(level: level, file: file)
    return Jack.self
  }

}

// MARK: - Compose log message
extension Jack {

  public enum Subsystem {
    case app
    case fileFunction
    case custom(String)
  }

  private static let _appName = ProcessInfo.processInfo.processName

  /**
   It is the designated method that other public logging methods delegate to.
   It composes log line(s) to feed into DDLogXXXX functions

   - parameter message:  message content
   - parameter subsystem:   one of .app | .fileFunction | .text(<whatever you want>)
   - parameter file:     file name of call site (usually captured automatically)
   - parameter function: function / method name of the call site (usually captured automatically)

   - returns: the line(s) string with which to feed the DDLogXXXX functions
   */


  /// It is the designated method that other public logging methods delegate to.
  /// It composes log line(s) to feed into DDLogXXXX functions
  ///
  /// - Parameters:
  ///   - message: message directly from user
  ///   - subsystem: [.app | .fileFunction | .custom(...)
  ///   - file: file name (extension stripped)
  ///   - function: function name
  /// - Returns: It combine the `subsystem` and `message` into a single string for passing to the DDLogXXX functions
  fileprivate static func _compose(
    _ message: String,
    _ subsystem: Subsystem,
    _ file: StaticString = #file,
    _ line: UInt = #line,
    _ function: StaticString
  ) -> String {

    var prefix: String
    switch subsystem {
    case .app:
      prefix = _appName
    case .fileFunction:
      let fileName = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
      prefix = "\(fileName).\(function) @\(line)"
    case .custom(let content):
      prefix = content
    }

    self.assert(!prefix.contains("\0"), "Should not contain null character")
    return "\(prefix)\0\(message)"
  }

}

// MARK: - Logging
extension Jack {

  private static func _canLog(flag: DDLogFlag, file: StaticString) -> Bool {
    return flag.rawValue & _level(of: file).rawValue != 0
  }

  public static func error(
    _ message: @autoclosure () -> String,
    from subsystem: Subsystem = .fileFunction,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .error, file: file) {
      let message = _compose(message(), subsystem, file, line, function)
      DDLogError(message, level: _level(of: file))
    }
  }

  public static func warn(
    _ message: @autoclosure () -> String,
    from subsystem: Subsystem = .fileFunction,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .warning, file: file) {
      let message = _compose(message(), subsystem, file, line, function)
      DDLogWarn(message, level: _level(of: file))
    }
  }

  public static func info(
    _ message: @autoclosure () -> String,
    from subsystem: Subsystem = .fileFunction,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .info, file: file) {
      let message = _compose(message(), subsystem, file, line, function)
      DDLogInfo(message, level: _level(of: file))
    }
  }

  public static func debug(
    _ message: @autoclosure () -> String,
    from subsystem: Subsystem = .fileFunction,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .debug, file: file) {
      let message = _compose(message(), subsystem, file, line, function)
      DDLogDebug(message, level: _level(of: file))
    }
  }

  public static func verbose(
    _ message: @autoclosure () -> String,
    from subsystem: Subsystem = .fileFunction,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    if _canLog(flag: .verbose, file: file) {
      let message = _compose(message(), subsystem, file, line, function)
      DDLogVerbose(message, level: _level(of: file))
    }
  }

}

    }
  }

}
