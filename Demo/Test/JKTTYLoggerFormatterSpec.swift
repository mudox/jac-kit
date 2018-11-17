import XCTest

import Nimble
import Quick

@testable import JacKit

/// The fake DDLogMessage to feed to formatter
private func logMessage(format: Jack.Format) -> DDLogMessage {
  let pkg = pack(Jack.Scope("Logging.Scope")!, "Logging message text", format, "file.swift", "function", 2018)
  return DDLogMessage(
    message: pkg,
    level: .verbose, flag: .info,
    context: 0,
    file: "file.swift", function: "function", line: 3,
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
