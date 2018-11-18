import XCTest

import Nimble
import Quick

@testable import JacKit

class JackReportingSpec: QuickSpec { override func spec() {

  it("report app state changes") {
    Jack.startReportingAppStateChanges()
    Jack.stopReportingAppStatesChanges()
  }

  it("reportAppInfo") {
    Jack.reportAppInfo()
  }

} }
