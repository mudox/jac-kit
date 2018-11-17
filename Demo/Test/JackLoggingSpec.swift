import XCTest

import Nimble
import Quick

@testable import JacKit

class JackLoggingSpec: QuickSpec { override func spec() {

  describe("Jack+Logging") {

    let jack = Jack().set(level: .verbose)

    // MARK: Scope

    it("error") {
      jack.error("error message", format: .short)
    }

    it("warn") {
      jack.warn("warn message", format: .bare)
    }

    it("info") {
      jack.info("info message", format: .compact)
    }

    it("debug") {
      jack.debug("debug message", format: .noLocation)
    }

    it("verbose") {
      jack.verbose("verbose message", format: .noScope)
    }

  }

} }
