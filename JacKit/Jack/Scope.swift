import Foundation

import CocoaLumberjack

internal extension Jack {

  struct Scope {
    static let fallback = Scope("InvalidScope")!

    enum Kind {
      case normal
      case file
    }

    let string: String
    let kind = Kind.normal

    static func isValid(scopeString: String) -> Bool {
      // If already already checked
//      _lock.lock()
//      if _scopeLevels.keys.contains(scopeString) {
//        return true
//      }
//      _lock.unlock()

      let components = scopeString.split(separator: ".", omittingEmptySubsequences: false)

      guard !components.isEmpty else { return false }

      //      for text in components {
      //        if text.range(of: "^\\b.*\\b$", options: .regularExpression) == nil {
      //          return false
      //        }
      //      }

      return true
    }

    init?(_ string: String, kind: Kind = .normal) {
      guard Scope.isValid(scopeString: string) else {
        return nil
      }

      self.string = string
    }

    var superScopeStrings: [String] {

      let first = string.components(separatedBy: ".")[...]

      return sequence(first: first) {
        let next = $0.dropLast()
        return next.isEmpty ? nil : next
      }.map {
        $0.joined(separator: ".")
      }
    }

  }

}

