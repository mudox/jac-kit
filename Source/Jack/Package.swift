import Foundation

internal extension Jack {

  struct Package: Codable {

    init(
      scope: Jack.Scope,
      message: String,
      format: Jack.Format,
      file: StaticString,
      function: StaticString,
      line: UInt
    ) {
      self.scope = scope.string
      self.message = message
      self.format = format.rawValue
      self.file = file.description
      self.function = function.description
      self.line = line
    }

    // Jack.Scope.string
    let scope: String

    // The message payload
    let message: String

    // Jack.format.rawValue
    let format: Int

    // #file
    let file: String
    // #function
    let function: String
    // #line
    let line: UInt

    static func fallbackString(
      error: Error? = nil,
      file: StaticString = #file,
      function: StaticString = #function,
      line: UInt = #line
    )
      -> String {
      let message: String
      if let error = error {
        message = "JSON encoding failed with: \(error)"
      } else {
        message = "JSON encoding failed"
      }

      let package = Package(
        scope: Jack.Scope("Jack.Package")!,
        message: message,
        format: [],
        file: file, function: function, line: line
      )

      // swiftlint:disable:next force_try
      let data = try! JSONEncoder().encode(package)
      return String(data: data, encoding: .utf8)!
    }

    var messageString: String {
      do {
        let data = try JSONEncoder().encode(self)
        return String(data: data, encoding: .utf8)!
      } catch {
        return Package.fallbackString(error: error)
      }
    }

  } // struct Package

} // internal extension Jack
