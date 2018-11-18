import XCTest

import Nimble
import Quick

@testable import JacKit

enum SomeError: Error {
  case error
}

class JackPackageSpec: QuickSpec { override func spec() {

  it("fallbackString") {
    let string = Jack.Package.fallbackString(error: SomeError.error)
    let data = string.data(using: .utf8)!
    let package = try! JSONDecoder().decode(Jack.Package.self, from: data)

    expect(package.message).to(beginWith("JSON encoding failed with:"))
    expect(package.messageString) == string
  }

  it("messageString") {
    let package = Jack.Package(
      scope: Jack.Scope("A.B")!,
      message: "C",
      format: [],
      file: #file, function: #function, line: #line
    )

    let string = package.messageString
    expect(string).to(contain([
      "\"scope\":\"A.B\"",
      "\"message\":\"C\"",
    ]))
  }

} }
