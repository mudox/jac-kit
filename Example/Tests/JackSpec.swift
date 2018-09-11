import XCTest

import Quick
import Nimble

@testable import JacKit

class StringSpec: QuickSpec {
  override func spec() {

    describe("Jack") {

      it("init validate scope string") {
        let expects = [
          "onlyOneComponent": true,
          "io.gihut.mudox.JacKit.Jack": true,
          ".": false,
          "..": false,
          "": false,
          "have. space.around .componnets": false,
          "have..contiguous...dots": false,
          ".start.with.a.dot": false,
          "end.with.a.dot.": false,
        ]

        expects.forEach { text, result in
          print("🍋 try \(String(reflecting: text))")
          expect(Jack.Scope.isValidScopeString(text)) == result
        }
      } // it("init")
      
      it("manages level") {
        expect(Jack("a").lookupLevel())
          .to(equal(Jack.LevelLookup.root))
        expect(Jack("b", level: .debug).lookupLevel())
          .to(equal(Jack.LevelLookup.set(.debug)))
        expect(Jack("b.c").lookupLevel())
          .to(equal(Jack.LevelLookup.inherit(.debug, from: "b")))
        
        let b = Jack("b")
        let c = Jack("b.c")
        let d = c.descendant("d.dd.ddd")
        expect(b.lookupLevel())
          .to(equal(Jack.LevelLookup.set(.debug)))
        
        b.setLevel(.warning)
        expect(b.lookupLevel())
          .to(equal(Jack.LevelLookup.set(.warning)))
        expect(c.lookupLevel()) == .inherit(.warning, from: "b")
        expect(d.lookupLevel()) == .inherit(.warning, from: "b")

        c.setLevel(.error)
        expect(c.level) == .error
      }

    } // describe("Jack")
  }
  
}
