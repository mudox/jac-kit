import Foundation

import CocoaLumberjack

// MARK: - Jack.ScopeRoster

extension Jack {

  internal enum ScopeRoster {
    static let lock = NSRecursiveLock()
    static var items = [String: Item]()
  }

}

// MARK: - Jack.ScopeRoster.Item

extension Jack.ScopeRoster {

  struct Item {

    var level: DDLogLevel?
    var options: Jack.Options?

    init() {
      level = nil
      options = nil
    }

  }

}

// MARK: - Lookup in ScopeRoster

internal extension Jack.ScopeRoster {

  enum LookupResult<T: HasFallback>: Equatable {

    case set(T)
    case inherit(T, from: String)
    case fallback

    var value: T {
      switch self {
      case let .set(lvl):
        return lvl
      case .inherit(let lvl, from: _):
        return lvl
      case .fallback:
        return T.fallback
      }
    }

  }

  static func lookup<T: HasFallback>(_: T.Type, scope: Jack.Scope, keyPath: KeyPath<Item, T?>) -> LookupResult<T> {

    lock.lock(); defer { lock.unlock() }

    if let value = items[scope.string]?[keyPath: keyPath] {
      return .set(value)
    }

    for scopeString in scope.superScopeStrings.dropFirst() {
      if let value = items[scopeString]?[keyPath: keyPath] {
        return .inherit(value, from: scopeString)
      }
    }

    return .fallback

  }

  static func set<T: HasFallback>(_ value: T?, scope: Jack.Scope, keyPath: WritableKeyPath<Item, T?>) {
    lock.lock()
    items[scope.string, default: Item()][keyPath: keyPath] = value
    lock.unlock()
  }

}
