import Foundation

private let _lock = NSRecursiveLock()
private var _scopeLevels: [String: DDLogLevel] = [:]

private func _setLevel(_ level: DDLogLevel, for scope: String) {
  _lock.lock()
  _scopeLevels[scope] = level
  _lock.unlock()
}



public final class Jack {

  public struct Scope {
    
    static func isValidScope(_ text: String) -> Bool {
      // If already already checked
      _lock.lock()
      if _scopeLevels.keys.contains(text) {
        return true
      }
      _lock.unlock()
      
      let components = text.split(separator: ".", omittingEmptySubsequences: false)
      
      guard !components.isEmpty else { return false }
      
      for text in components {
        if text.range(of: "^\\b.*\\b$", options: .regularExpression) == nil {
          return false
        }
      }
      
      return true
    }
    static let fallback = Scope("FALLBACK")!

    let string: String

    init?(_ string: String) {

      guard Scope.isValidScope(string) else {
        return nil
      }

      self.string = string
    }


    fileprivate var _subscopes: [String] {
      let first = string.components(separatedBy: ".")[...]

      return sequence(first: first) {
        let next = $0.dropLast()
        return next.isEmpty ? nil : next
      }.map {
        return $0.joined(separator: ".")
      }
    }

  }

  enum LevelLookup: Equatable {
    case set(DDLogLevel)
    case inherit(DDLogLevel, from: String)
    case root

    var level: DDLogLevel {
      switch self {
      case .set(let lvl):
        return lvl
      case .inherit(let lvl, from: _):
        return lvl
      case .root:
        return Jack.rootLevel
      }
    }
  }

  static let rootLevel = DDLogLevel.verbose

  let scope: Scope

  public init(scope: String, level: DDLogLevel? = nil) {

    if let s = Scope(scope) {
      self.scope = s
    } else {
      print("""
        invalid scope string: \(scope), fallback to use the special fallback \
        scope - "\(Scope.fallback).string"
        """)
      self.scope = Scope.fallback
    }

    if let level = level {
      _setLevel(level, for: scope)
    }
  }

  func lookupLevel() -> LevelLookup {
    _lock.lock(); defer { _lock.unlock() }

    if let level = _scopeLevels[scope.string] {
      return .set(level)
    }

    for s in scope._subscopes.dropFirst() {
      if let level = _scopeLevels[s] {
        return .inherit(level, from: s)
      }
    }

    return .root
  }

  public var level: DDLogLevel {
    return lookupLevel().level
  }

  @discardableResult
  public func setLevel(_ level: DDLogLevel) -> Jack {
    _setLevel(level, for: scope.string)
    return self
  }

}
