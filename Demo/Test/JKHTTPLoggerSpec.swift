import XCTest

import Nimble
import Quick

@testable import JacKit

class JKHTTPLoggerSpec: QuickSpec { override func spec() {
  
  it("sessionID") {
    let jack = Jack()
    jack.info("\(JKHTTPLogger.serverURL)")
    jack.info("\(JKHTTPLogger.sessionID)")
  }

} }
