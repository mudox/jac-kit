import XCTest

import Nimble
import Quick

@testable import JacKit

/// The fake DDLogMessage to feed to formatter
private func logMessage(format: Jack.Format) -> DDLogMessage {
  let package = Jack.Package(
    scope: Jack.Scope("SCOPE")!,
    message: "MESSAGE",
    format: format,
    file: "FILE", function: "FUNCTION", line: 1
  )

  return DDLogMessage(
    message: package.messageString,
    level: .verbose, flag: .info,
    context: 0,
    file: "FILE", function: "FUNCTION", line: 1,
    tag: nil, options: [],
    timestamp: Date()
  )
}

class JKTTYLoggerFormatterSpec: QuickSpec { override func spec() {

  describe("formatLogMessage") {

    let icon = JKTTYLoggerFormatter.icon(for: .info)

    // MARK: Default format

    it("Default format") {
      let msg = logMessage(format: .fallback)

      let a = JKTTYLoggerFormatter().format(message: msg)!
      let b = """
      \(icon) SCOPE
         MESSAGE
         ▹ FILE・FUNCTION・1
      """

      print(" a: \(String(reflecting: a))")
      print("b: \(String(reflecting: b))")

      expect(a) == b
    }

    // MARK: noIcon

    it("noIcon") {
      Jack("Default.icon").info("using `.short` format option", format: .short)
      Jack("🔥 Custom.icon").info("using `[.noIcon, .short]` format option", format: [.noIcon, .short])

      let msg = logMessage(format: .noIcon)

      let a = JKTTYLoggerFormatter().format(message: msg)!
      let b = """
      SCOPE
         MESSAGE
         ▹ FILE・FUNCTION・1
      """

      print(" a: \(String(reflecting: a))")
      print("b: \(String(reflecting: b))")

      expect(a) == b
    }

    // MARK: noLocation

    it("noLocation") {
      // a
      let msg = logMessage(format: .noLocation)
      let a = JKTTYLoggerFormatter().format(message: msg)!

      // b
      let b = """
      \(icon) SCOPE
         MESSAGE
      """

      print("a: \(String(reflecting: a))")
      print("b: \(String(reflecting: b))")

      expect(a) == b
    }

    // MARK: noScope

    it("noScope") {
      // a
      let msg = logMessage(format: .noScope)
      let a = JKTTYLoggerFormatter().format(message: msg)!

      // b
      let b = """
      \(icon) MESSAGE
         ▹ FILE・FUNCTION・1
      """

      print("a: \(String(reflecting: a))")
      print("b: \(String(reflecting: b))")

      expect(a) == b
    }

    // MARK: bare
    
    it("bare") {
      // a
      let msg = logMessage(format: .bare)
      let a = JKTTYLoggerFormatter().format(message: msg)!
      
      // b
      let b = """
      MESSAGE
      """
      
      print("a: \(String(reflecting: a))")
      print("b: \(String(reflecting: b))")
      
      expect(a) == b
    }
    // MARK: short
    
    it("short") {
      // a
      let msg = logMessage(format: .short)
      let a = JKTTYLoggerFormatter().format(message: msg)!
      
      // b
      let b = """
      \(icon) SCOPE - MESSAGE
      """
      
      print("a: \(String(reflecting: a))")
      print("b: \(String(reflecting: b))")
      
      expect(a) == b
    }
    
  } // describe("Jack.Scope")

} }
