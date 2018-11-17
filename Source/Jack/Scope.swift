import Foundation

import CocoaLumberjack

internal extension Jack {

  struct Scope {
    static let fallback = Scope("InvalidScope")!

    // swiftlint:disable:next nesting
    enum Kind {
      case normal
      case file
    }

    let string: String
    let kind: Kind

    static func isValid(scopeString: String) -> Bool {
      let components = scopeString.split(separator: ".", omittingEmptySubsequences: false)

      // Must have at least one component.
      guard !components.isEmpty else { return false }

      // Must NOT contain empty string `""` components.
      guard components.firstIndex(of: "") == nil else { return false }

      return true
    }

    init?(_ string: String, kind: Kind = .normal) {
      guard Scope.isValid(scopeString: string) else {
        return nil
      }

      self.string = string
      self.kind = kind
    }

    var superScopeStrings: [String] {

      let first = string.components(separatedBy: ".")

      return sequence(first: first) {
        let next = $0.dropLast()
        return next.isEmpty ? nil : Array(next)
      }
      .map {
        $0.joined(separator: ".")
      }
    }

  }

}
