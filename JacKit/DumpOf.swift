import Foundation

public func dump<T>(of value: T) -> String {
  var text = ""
  Swift.dump(value, to: &text)
  return text
}

public func description(ofHTTPStatusCode code: Int) -> String {
  let description = HTTPURLResponse.localizedString(forStatusCode: code)
  return "\(code) \(description.uppercased())"
}

public extension String {

  func indented(by n: Int) -> String {
    let prefix = String(repeating: " ", count: n)
    return components(separatedBy: "\n")
      .map { prefix + $0 }
      .joined(separator: "\n")
  }

}
