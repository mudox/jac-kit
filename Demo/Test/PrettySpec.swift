import XCTest

import Nimble
import Quick

@testable import JacKit

class PrettySpec: QuickSpec { override func spec() {

  describe("String") {

    // MARK: Scope

    it("indented") {
      let src = """
      line 1
      line 2
      """

      let dest = src.indented(by: 2)
      expect(dest) == """
        line 1
        line 2
      """
    }

    it("stringFromHTTPStatusCode") {
      let dest = string(fromHTTPStatusCode: 200)
      expect(dest) == "200 NO ERROR"
    }

    it("dump") {
      let dest = dump(of: 2018)
      expect(dest) == "- 2018\n"
    }

  }

} }
