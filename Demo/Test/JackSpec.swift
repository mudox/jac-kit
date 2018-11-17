import XCTest

import Nimble
import Quick

@testable import JacKit

class JackSpec: QuickSpec { override func spec() {

    beforeEach {
      Jack.ScopeRoster.items.removeAll()
    }

    // MARK: Scope

    it("has scope") {
      let jack = Jack("A.B.C")
      expect(jack.scope.string) == "A.B.C"
    }

    it("fallback scope") {
      let jack = Jack(".A.C.")
      expect(jack.scope.string) == Jack.Scope.fallback.string
    }
    
    // MARK: Creation
    
    it("descendant") {
      let jack = Jack("A.B").descendant("C.D")
      expect(jack.scope.string) == "A.B.C.D"
    }
    
    it("function") {
      let jack = Jack("A.B").function()
      expect(jack.scope.string) == "A.B.spec"
    }

    // MARK: Level

    it("sets level") {

      let jack = Jack()
      jack.set(level: .info)
      expect(jack.level) == .info

    }

    it("inherits level") {

      Jack("A").set(level: .info)
      expect(Jack("A.B.C").level) == .info

    }

    it("fallback level") {

      expect(Jack("A.B").level) == DDLogLevel.fallback

    }

    // MARK: Format

    it("sets format") {

      let jack = Jack()
      jack.set(format: .noIcon)
      expect(jack.format) == .noIcon

    }

    it("inherits format") {

      Jack("A").set(format: .noIcon)
      expect(Jack("A.B.C").format) == .noIcon

    }

    it("fallback format") {

      expect(Jack("A.B").format) == Jack.Format.fallback

    }

} }
