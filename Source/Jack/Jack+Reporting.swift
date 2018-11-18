import UIKit

private let jack = Jack()

private var tokens: [NSObjectProtocol] = []

public extension Jack {

  static func startReportingAppStateChanges() {
    if !tokens.isEmpty {
      stopReportingAppStatesChanges()
    }

    tokens = applicationStateDescriptions.map { item in
      return NotificationCenter.default.addObserver(forName: item.key, object: nil, queue: nil, using: { _ in
        Jack().debug("🌗 \(item.value)", format: .bare)
      })
    }
  }

  static func stopReportingAppStatesChanges() {
    guard tokens.isEmpty  else {
      jack.function().warn("\(#function) is invoked when there is no tokens to remove")
      return
    }

    tokens.forEach(NotificationCenter.default.removeObserver)
  }

  // swiftlint:disable:next function_body_length
  static func reportAppInfo() {
    let appName = ProcessInfo.processInfo.processName
    let bundleID = Bundle.main.bundleIdentifier

    let release = Bundle.main
      .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let build = Bundle.main
      .object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String

    let isDebug: Bool
    #if DEBUG
      isDebug = true
    #else
      isDebug = false
    #endif

    let isSimulator: Bool
    #if targetEnvironment(simulator)
      isSimulator = true
    #else
      isSimulator = false
    #endif

    let deviceName = UIDevice.current.name
    let deviceModel = UIDevice.current.model
    let deviceID = UIDevice.current.identifierForVendor?.uuidString

    let systemName = UIDevice.current.systemName
    let systemVersion = UIDevice.current.systemVersion

    let lines = """
    🚀 \(appName)
    [App]
      - Name       :   \(appName)
      - ID         :   \(bundleID ?? "N/A")
      - Release    :   \(release ?? "N/A")  (CFBundleShortVersionString)
      - Build      :   \(build ?? "N/A") (kCFBundleVersionKey)
      - Debug      :   \(isDebug)
      - Simulator  :   \(isSimulator)
    [Device]
      - Name       :   \(deviceName)
      - Model      :   \(deviceModel)
      - UUID       :   \(deviceID ?? "N/A")
    [System]
      - Name       :   \(systemName)
      - Version    :   \(systemVersion)
    """ + "\n"

    Jack(appName).info(lines, format: .bare)
  }
}
