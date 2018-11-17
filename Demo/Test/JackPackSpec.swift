import XCTest

import Nimble
import Quick

@testable import JacKit

class JackPackSpec: QuickSpec {

  fileprivate func testPack(
    _ scope: Jack.Scope,
    _ format: Jack.Format,
    _ file: StaticString,
    _ function: StaticString,
    _ line: UInt,
    _ message: String
  ) {
    let pkgString = pack(
      scope,
      "Logging message text",
      format,
      file, function, line
    )

    let pkgData = pkgString.data(using: .utf8)!
    let pkgObject = try! JSONSerialization.jsonObject(with: pkgData, options: []) as! [String: Any]

    expect((pkgObject["scope"] as! String)) == ((scope.kind == .file) ? "File:\(scope.string)" : scope.string)
    expect((pkgObject["message"] as! String)) == message.description
    expect((pkgObject["file"] as! String)) == file.description
    expect((pkgObject["function"] as! String)) == "\(function)"
    expect((pkgObject["line"] as! UInt)) == line
    expect((pkgObject["format"] as! Int)) == format.rawValue
  }

  override func spec() {

    // MARK: normal kind

    it("normal kind") {

      let scope = Jack.Scope("Logging.Scope")!
      let message = "Logging message text"
      let format = Jack.Format.noIcon
      let file: StaticString = "file.swift"
      let function: StaticString = "function"
      let line: UInt = 2018

      self.testPack(scope, format, file, function, line, message)

    }

    // MARK: file kind

    it("file kind") {

      let scope = Jack.Scope("Logging.Scope", kind: .file)!
      let message = "Logging message text"
      let format = Jack.Format.noIcon
      let file: StaticString = "file.swift"
      let function: StaticString = "function"
      let line: UInt = 2018

      self.testPack(scope, format, file, function, line, message)

    }

  }

}
