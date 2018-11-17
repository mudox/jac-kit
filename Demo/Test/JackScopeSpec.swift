import XCTest

import Nimble
import Quick

@testable import JacKit

class JackScopeSpec: QuickSpec {
  override func spec() {

    describe("Jack.Scope") {

      it("validate scope string") {

        let samples = [
          "onlyOneComponent": true,
          "io.gihut.mudox.JacKit.Jack": true,
          ".": false, // empty component
          "..": false, // more empty component
          "": false, // no component
          "<name>.[with].{special}.symbols": true, // allow symbols
          "have. space.around .componnets": true, // space is allowed
          "have..contiguous...dots": false, // contiguous empty componnet
          ".start.with.a.dot": false, // head empty component
          "end.with.a.dot.": false, // trailing empty component
        ]

        samples.forEach { text, result in
          print("🍋 validate \(String(reflecting: text))")
          expect(Jack.Scope.isValid(scopeString: text)) == result
        }

      }

    } // describe("Jack.Scope")

    describe("Jack.ScopeRoster") {

      afterEach {
        Jack.ScopeRoster.items = [:]
      }

      it("LookupResult.fallback") {
        let lookup = Jack.ScopeRoster.lookup(
          Jack.Format.self,
          scope: Jack.Scope("a")!,
          keyPath: \Jack.ScopeRoster.Item.options
        )

        expect({
          guard case Jack.ScopeRoster.LookupResult.fallback = lookup else {
            return .failed(reason: "wrong enum case")
          }
          return .succeeded
        }).to(succeed())
        
        expect(lookup.value) == Jack.Format.fallback
      }

      it("LookupResult.set") {
        Jack.ScopeRoster.set(
          Jack.Format.noIcon,
          scope: Jack.Scope("b")!,
          keyPath: \Jack.ScopeRoster.Item.options
        )

        let lookup = Jack.ScopeRoster.lookup(
          Jack.Format.self,
          scope: Jack.Scope("b")!,
          keyPath: \Jack.ScopeRoster.Item.options
        )

        expect({
          guard
            case let Jack.ScopeRoster.LookupResult.set(opt) = lookup,
            opt == Jack.Format.noIcon
          else {
            return .failed(reason: "wrong enum case or associated value")
          }
          
          return .succeeded
        }).to(succeed())
        
        expect(lookup.value) == Jack.Format.noIcon
      }

      it("LookupResult.inherit") {
        Jack.ScopeRoster.set(
          Jack.Format.noIcon,
          scope: Jack.Scope("b")!,
          keyPath: \Jack.ScopeRoster.Item.options
        )
        
        let lookup = Jack.ScopeRoster.lookup(
          Jack.Format.self,
          scope: Jack.Scope("b.c")!,
          keyPath: \Jack.ScopeRoster.Item.options
        )
        
        expect({
          guard
            case let Jack.ScopeRoster.LookupResult.inherit(opt, from: parent) = lookup,
            opt == Jack.Format.noIcon,
            parent == "b"
            else {
              return .failed(reason: "wrong enum case or associated value")
          }
          
          return .succeeded
        }).to(succeed())
        
        expect(lookup.value) == Jack.Format.noIcon
      }

    } // describe("Jack.ScopeRoster")
  }

}
