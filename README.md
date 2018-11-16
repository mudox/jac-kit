# JacKit

![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)
[![GitHub license](https://img.shields.io/github/license/mudox/jac-kit.svg)](https://github.com/mudox/jac-kit/blob/master/LICENSE)
[![Travis (.com)](https://img.shields.io/travis/com/mudox/jac-kit.svg)](https://travis-ci.com/mudox/jac-kit)
[![Codecov](https://img.shields.io/codecov/c/github/mudox/jac-kit.svg)](https://codecov.io/gh/mudox/mudox-kit)
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/mudox/jac-kit.svg)](https://codeclimate.com/github/mudox/jac-kit/maintainability)

JacKit is a scope based logger inspired from [Python logging module]. It is based on the [CocoaLumberjack] framework.

## Features

- [x] Modern Swifty interafce.
- [x] Scope based logging control.
  - [x] Flexible & eye-saving console output formatting.
  - [x] Severity level for each scope or inherit from upstream.
- [x] ~A HTTP logger to direct logs to be shown outside of Xcode, e.g. on terminal emulators (Current broken on the server-side).~

## Installation

<!--JacKit is available through [CocoaPods](http://cocoapods.org). To install-->
<!--it, simply add the following line to your Podfile:-->

JacKit is currently not published.

```ruby
pod 'JacKit' :git => 'https://github.com/mudox/jac-kit.git'
```

# Usage

```swift
// NetworkService.swift

import JacKit

private let jack = Jack("MyApp.NetworkService")
  .set(level: .warning)      // set severity level at upper scope
  .set(options: .short)      // set formatting optoins at upper scope

class NetworkService {

  func request() {
    jack
      .descendant("request") // sub-scope "MyApp.NetworkService.request"
      .info("request ...")   // message with severity level `.info`
  }

}

```

## Author

Mudox

## License

JacKit is available under the MIT license. See the LICENSE file for more info.

[CocoaLumberjack]: https://cocoalumberjack.github.io
[Python logging module]: https://docs.python.org/3/library/logging.html
