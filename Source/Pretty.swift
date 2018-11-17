import Foundation

/// Get the string generated from `Swift.dump(...)`.
/// This is the most generic verion of dump(of:)
///
/// - Parameter value: The value to dump.
/// - Returns: The dumped string.
public func dump<T>(of value: T) -> String {
  var text = ""
  Swift.dump(value, to: &text)
  return text
}

public func string(fromHTTPStatusCode code: Int) -> String {
  let description = HTTPURLResponse.localizedString(forStatusCode: code)
  return "\(code) \(description.uppercased())"
}

public extension String {

  /// Indent multi-lines with specified spaces.
  ///
  /// - Parameter n: The number of spaces to insert before each line.
  /// - Returns: The indented lines.
  func indented(by spaceCount: Int) -> String {
    let prefix = String(repeating: " ", count: spaceCount)
    return prefixingEachLine(with: prefix)
  }

  /// Padding the head of each line with the specified prefix.
  ///
  /// - Parameter prefix: The prefix to be inserted before each line.
  /// - Returns: The new lines.
  func prefixingEachLine(with prefix: String) -> String {
    return components(separatedBy: "\n")
      .map { prefix + $0 }
      .joined(separator: "\n")
  }

}
