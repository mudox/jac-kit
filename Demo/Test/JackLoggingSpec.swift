import XCTest

import Nimble
import Quick

@testable import JacKit

class JackLoggingSpec: QuickSpec { override func spec() {

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

  it("assert") {
    #if DEBUG
      expect {
        jack.assert(true, "message")
      }.notTo(throwAssertion())

      expect {
        jack.assert(false, "message")
      }.to(throwAssertion())
    #else
      expect {
        jack.assert(true, "message")
      }.toNot(throwAssertion())

      expect {
        jack.assert(false, "message")
      }.toNot(throwAssertion())
    #endif
  }

  it("failure") {
    #if DEBUG
      expect {
        jack.failure("message")
      }.to(throwAssertion())
    #else
      expect {
        jack.failure("message")
      }.toNot(throwAssertion())
    #endif
  }

} }
