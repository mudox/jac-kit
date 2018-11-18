import XCTest

import Nimble
import Quick

@testable import JacKit

class JKHTTPLoggerSpec: QuickSpec { override func spec() {
  
  it("sessionID") {
    expect(JKHTTPLogger.sessionID).notTo(beNil())
  }
  
  it("serverURL") {
    expect(JKHTTPLogger.serverURL).notTo(beNil())
  }

} }
