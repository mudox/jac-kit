import Foundation

extension Jack {

  public static func dump<T>(of value: T) -> String {
    var text = ""
    Swift.dump(value, to: &text)
    return text
  }

  public static func description(ofHTTPStatusCode code: Int) -> String {
    let description = HTTPURLResponse.localizedString(forStatusCode: code)
    return "\(code) \(description.uppercased())"
  }

}

extension String {
  public func indented(_ n: Int) -> String {
    let prefix = String(repeating: " ", count: n)
    return components(separatedBy: "\n")
      .map { prefix + $0 }
      .joined(separator: "\n")
  }
}

extension HTTPURLResponse {
  open override var debugDescription: String {
    return "HTTPURLResponse"
  }
}
