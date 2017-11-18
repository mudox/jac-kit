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

// MARK: - Logging method
extension Jack {

  public enum Subsystem {
    case appName, fileFunctionName
    case text(String)
  }

  public enum Prefix {
    case appName, fileFunctionName
    case text(String)
  }

  static let appName = ProcessInfo.processInfo.processName

  static let indentRegex = try! NSRegularExpression(pattern: "\\n([^>]{2})", options: [])

  /**
   It is the designated method that other public logging methods delegate to.
   It composes log line(s) to feed into DDLogXXXX functions

   - parameter message:  message content
   - parameter prefix:   one of .appName | .fileFunctionName | .text(<whatever you want>)
   - parameter file:     file name of call site (usually captured automatically)
   - parameter function: function / method name of the call site (usually captured automatically)

   - returns: the line(s) string with which to feed the DDLogXXXX functions
   */
  fileprivate static func logStringWith(
    _ message: String,
    _ prefix: Prefix,
    _ file: String,
    _ function: String
  ) -> String {

    // prefix continued none empty lines with `>> `
    var log = indentRegex.stringByReplacingMatches(
      in: message,
      options: [],
      range: NSMakeRange(0, (message as NSString).length),
      withTemplate: "\n>> $1"
    )

    // prepend subsystem info
    switch prefix {

    case .appName:
      log = "\(appName): " + log

    case .fileFunctionName:
      let fileName = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
      log = "\(fileName) \(function)] " + log // use `]` as terminator here because `:` may be a valid symbol in function names
      
    case .text(let content):
      log = "\(content): " + log
    }

    return log
  }

  public static func error(
    _ message: @autoclosure () -> String,
    withPrefix prefix: Prefix = .fileFunctionName,
    _ file: String = #file,
    _ function: String = #function
  ) {

    if DDLogFlag.error.rawValue & levelOfFile(file).rawValue != 0 {
      DDLogError(logStringWith(message(), prefix, file, function), level: levelOfFile(file))
    }
  }

  public static func warn(
    _ message: @autoclosure () -> String,
    withPrefix prefix: Prefix = .fileFunctionName,
    _ file: String = #file,
    _ function: String = #function
  ) {

    if DDLogFlag.warning.rawValue & levelOfFile(file).rawValue != 0 {
      DDLogWarn(logStringWith(message(), prefix, file, function), level: levelOfFile(file))
    }
  }

  public static func info(
    _ message: @autoclosure () -> String,
    withPrefix prefix: Prefix = .fileFunctionName,
    _ file: String = #file,
    _ function: String = #function
  ) {

    if DDLogFlag.info.rawValue & levelOfFile(file).rawValue != 0 {
      DDLogInfo(logStringWith(message(), prefix, file, function), level: levelOfFile(file))
    }
  }

  public static func debug(
    _ message: @autoclosure () -> String,
    withPrefix prefix: Prefix = .fileFunctionName,
    _ file: String = #file,
    _ function: String = #function
  ) {

    if DDLogFlag.debug.rawValue & levelOfFile(file).rawValue != 0 {
      DDLogDebug(logStringWith(message(), prefix, file, function), level: levelOfFile(file))
    }
  }

  public static func verbose(
    _ message: @autoclosure () -> String,
    withPrefix prefix: Prefix = .fileFunctionName,
    _ file: String = #file,
    _ function: String = #function
  ) {

    if DDLogFlag.verbose.rawValue & levelOfFile(file).rawValue != 0 {
      DDLogVerbose(logStringWith(message(), prefix, file, function), level: levelOfFile(file))
    }
  }

}
