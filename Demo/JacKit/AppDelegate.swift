import UIKit

import JacKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)
    -> Bool
  {
    
    Jack.reportAppInfo()
    Jack.startReportingAppStateChanges()
    
    return true
  }

}
