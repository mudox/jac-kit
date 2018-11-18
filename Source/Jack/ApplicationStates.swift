import UIKit

internal let applicationStateDescriptions: [Notification.Name: String] = [
  // Launching state
  UIApplication.didFinishLaunchingNotification: "Application did finish launching",

  // Active state
  UIApplication.didBecomeActiveNotification: "Application did become active",
  UIApplication.willResignActiveNotification: "Application will resign active",

  // Background state
  UIApplication.didEnterBackgroundNotification: "Application did enter background",
  UIApplication.willEnterForegroundNotification: "Application will enter foreground",

  // Terminat state
  UIApplication.willTerminateNotification: "Application will terminate",

  // Memory warning
  UIApplication.didReceiveMemoryWarningNotification: "Application did receive memory warning",

  // Significant time changing
  UIApplication.significantTimeChangeNotification: "Application siginificant time change",

  // Status bar
  UIApplication.willChangeStatusBarOrientationNotification: "Application will change status bar orientation",
  UIApplication.didChangeStatusBarOrientationNotification: "Application did change status bar orientation",
  UIApplication.willChangeStatusBarFrameNotification: "Application will change status bar frame",
  UIApplication.didChangeStatusBarFrameNotification: "Application did change status bar frame",

  // Background refresh
  UIApplication.backgroundRefreshStatusDidChangeNotification: "Application did change background refresh status",

  // Protected data
  UIApplication.protectedDataWillBecomeUnavailableNotification: "Application prototected data will become unavailable",
  UIApplication.protectedDataDidBecomeAvailableNotification: "Application protected data did become available",
]
