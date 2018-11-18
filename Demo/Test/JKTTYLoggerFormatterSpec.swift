import XCTest

import Nimble
import Quick

@testable import JacKit

/// The fake DDLogMessage to feed to formatter
private func logMessage(format: Jack.Format) -> DDLogMessage {
  let package = Jack.Package(
    scope: Jack.Scope("Logging.Scope")!,
    message: "Logging message text",
    format: format,
    file: "file.swift", function: "function", line: 2018
  )
  return DDLogMessage(
    message: package.messageString,
    level: .verbose, flag: .info,
    context: 0,
    file: "file.swift", function: "function", line: 2018,
    tag: nil, options: [],
    timestamp: Date()
  )

}

class JKTTYLoggerFormatterSpec: QuickSpec { override func spec() {

  describe("formatLogMessage") {

    it("noIcon") {
      
      let msg = logMessage(format: .noIcon)
      let text = JKTTYLoggerFormatter().format(message: msg)
      expect(text) == """
      []
      """
      
    }

  } // describe("Jack.Scope")

} }
