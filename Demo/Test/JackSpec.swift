import XCTest

import Nimble
import Quick

@testable import JacKit

class JackSpec: QuickSpec { override func spec() {

  describe("Jack") {
    
    beforeEach {
      Jack.ScopeRoster.items.removeAll()
    }

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
    
  } // describe("Jack")

} }
