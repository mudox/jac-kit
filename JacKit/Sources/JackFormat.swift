import Foundation


public func pretty(of value: Any?, name: String? = nil, indent: Int = 2) -> String {
  var lines = ""
  dump(value, to: &lines, name: name, indent: indent)
  return lines
}

public func pretty(of error: NSError, label: String? = nil, indent: Int = 2) -> String {
  let lines = """
    - domain      : \(error.domain)
    - code        : \(error.code)
    - description : \(error.localizedDescription)
    - user info   :
    \(pretty(of: error.userInfo, indent: indent + 2))",
    """
  return lines
    .components(separatedBy: .newlines)
    .map { String(repeating: " ", count: indent) + $0 }
    .joined()
}
