//
//  Mudox.swift
//  YiDaIOSSwiftPractices
//
//  Created by Mudox on 9/9/16.
//  Copyright © 2016 Mudox. All rights reserved.
//

import Foundation
import CocoaLumberjack

// MARK: - Per-file severity level support
extension Jack {

  static var levelOfFile = [String: DDLogLevel]()

  /**
   In the start of each file that you want to set a per file debug severity level for, add following line:
   `fileprivate let jack = Jack.with(levelOfThisFile: .warning)`

   - parameter level:    DDLogLevel
   - parameter fileName: Auto passed by syntax #file. Ususally DO NOT specify it explicitly

   - returns: Jack.Type for compiler's happiness
   */
  public static func with(levelOfThisFile level: DDLogLevel, _ fileName: String = #file) -> Jack.Type {
    setLevelOfThisFile(level, fileName)
    return Jack.self
  }

  static func setLevelOfThisFile(_ level: DDLogLevel, _ fileName: String = #file) {
    levelOfFile[fileName] = level
  }

  static func levelOfFile(_ fileName: String) -> DDLogLevel {
    if let level = levelOfFile[fileName] {
      return level
    } else {
      return defaultDebugLevel
    }
  }

}

// MARK: - Private
extension Jack {

  public enum Subsystem {
    case app
    case fileFunction
    case custom(String)
  }

  static let appName = ProcessInfo.processInfo.processName

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
  fileprivate static func messagePartForDDLogMessage(
    _ message: String,
    _ subsystem: Subsystem,
    _ file: String,
    _ function: String
  ) -> String {

    var prefix: String
    switch subsystem {
    case .app:
      prefix = appName
    case .fileFunction:
      let fileName = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
      prefix = "\(fileName).\(function)"
    case .custom(let content):
      prefix = content
    }

    assert(!prefix.contains("\0"))
    return "\(prefix)\0\(message)"
  }

}

// MARK: - Public Interface
extension Jack {

  public static func error(
    _ message: @autoclosure () -> String,
    from subsystem: Subsystem = .fileFunction,
    _ file: String = #file,
    _ function: String = #function
  ) {

    if DDLogFlag.error.rawValue & levelOfFile(file).rawValue != 0 {
      DDLogError(messagePartForDDLogMessage(message(), subsystem, file, function), level: levelOfFile(file))
    }
  }

  public static func warn(
    _ message: @autoclosure () -> String,
    from subsystem: Subsystem = .fileFunction,
    _ file: String = #file,
    _ function: String = #function
  ) {

    if DDLogFlag.warning.rawValue & levelOfFile(file).rawValue != 0 {
      DDLogWarn(messagePartForDDLogMessage(message(), subsystem, file, function), level: levelOfFile(file))
    }
  }

  public static func info(
    _ message: @autoclosure () -> String,
    from subsystem: Subsystem = .fileFunction,
    _ file: String = #file,
    _ function: String = #function
  ) {

    if DDLogFlag.info.rawValue & levelOfFile(file).rawValue != 0 {
      DDLogInfo(messagePartForDDLogMessage(message(), subsystem, file, function), level: levelOfFile(file))
    }
  }

  public static func debug(
    _ message: @autoclosure () -> String,
    from subsystem: Subsystem = .fileFunction,
    _ file: String = #file,
    _ function: String = #function
  ) {

    if DDLogFlag.debug.rawValue & levelOfFile(file).rawValue != 0 {
      DDLogDebug(messagePartForDDLogMessage(message(), subsystem, file, function), level: levelOfFile(file))
    }
  }

  public static func verbose(
    _ message: @autoclosure () -> String,
    from subsystem: Subsystem = .fileFunction,
    _ file: String = #file,
    _ function: String = #function
  ) {

    if DDLogFlag.verbose.rawValue & levelOfFile(file).rawValue != 0 {
      DDLogVerbose(messagePartForDDLogMessage(message(), subsystem, file, function), level: levelOfFile(file))
    }
  }

}
