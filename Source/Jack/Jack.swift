import Foundation

public final class Jack {

  let scope: Scope

  public init(
    _ scope: String? = nil,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) {
    // Use file name as default scope string.
    let scopeString: String
    let kind: Scope.Kind
    if scope != nil {
      scopeString = scope!
      kind = .normal
    } else {
      scopeString = URL(fileURLWithPath: file.description).deletingPathExtension().lastPathComponent
      kind = .file
    }

    if let scope = Scope(scopeString, kind: kind) {
      self.scope = scope
    } else {
      print("""
      invalid scope string: \(String(describing: scope)), fallback to use the special fallback \
      scope - "\(Scope.fallback).string"
      """)
      self.scope = Scope.fallback
    }
  }

  // MARK: - Create Descendants

  /// Return a new Jack instance that is a descendant of the receiver whose scope
  /// is constructed by appending the argument scope string the one of the receiver.
  ///
  /// - Parameter scope: Descendant scope string.
  /// - Returns: Descendant scoped Jack instance.
  public func sub(_ scope: String) -> Jack {
    let newScope = self.scope.string + "." + scope
    return .init(newScope)
  }

  public func `func`(_ name: StaticString = #function) -> Jack {
    let nameString = name.description
    let index = nameString.firstIndex(of: "(") ?? nameString.endIndex
    let scope = String(nameString[nameString.startIndex..<index])
    return sub(scope)
  }

  // MARK: - Level

  public var level: DDLogLevel {
    return ScopeRoster
      .lookup(DDLogLevel.self, scope: scope, keyPath: \ScopeRoster.Item.level)
      .value
  }

  /// Associate level to its scope.
  ///
  /// - Parameter level: The DDLogLevel to associate with scope.
  /// - Returns: `self` to enabled chain of method calls.
  @discardableResult
  public func set(level: DDLogLevel?) -> Jack {
    ScopeRoster.set(level, scope: scope, keyPath: \ScopeRoster.Item.level)
    return self
  }

  // MARK: - Format

  public var format: Jack.Format {
    return ScopeRoster
      .lookup(Jack.Format.self, scope: scope, keyPath: \ScopeRoster.Item.options)
      .value
  }

  /// Associate options to its scope.
  ///
  /// - Parameter options: The `Jack.Options` to associate with its scope.
  /// - Returns: `self` to enabled chain of method calls.
  @discardableResult
  public func set(format: Jack.Format?) -> Jack {
    ScopeRoster.set(format, scope: scope, keyPath: \ScopeRoster.Item.options)
    return self
  }
}
