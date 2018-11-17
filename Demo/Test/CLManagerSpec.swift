import XCTest

import Nimble
import Quick

@testable import JacKit

class CLManagerSpec: QuickSpec { override func spec() {

  it("greetings") {
    expect(CLManager.greetings).notTo(beNil())
    expect(CLManager.greetings).notTo(beEmpty())
  }

} }
