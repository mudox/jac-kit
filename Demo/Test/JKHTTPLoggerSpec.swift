import XCTest

import Nimble
import Quick

@testable import JacKit

class JKHTTPLoggerSpec: QuickSpec { override func spec() {

  it("sessionIdentifier") {
    expect(JKHTTPLogger.sessionIdentifier).notTo(beNil())

  }

  it("serverURL") {
    if ProcessInfo.processInfo.environment["JAC_SRV_URL"] != nil {
      expect(JKHTTPLogger.serverURL).notTo(beNil())
    } else {
      expect(JKHTTPLogger.serverURL).to(beNil())
    }
  }

} }
