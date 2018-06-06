import Foundation

class Jack__unfinished {
  private static let defaultLevel = 1
  private static var scopeLevels: [String: Int] = [:]
  
  var scope: String
  var level: Int {
    let scopes = sequence(first: self.scope.components(separatedBy: ".")[...]) {
      guard !$0.isEmpty else { return nil }
      return $0.dropLast()
      }.map { String($0.joined(separator: ".")) }
    
    for s in scopes {
      if let level = Jack__unfinished.scopeLevels[s] {
        return level
      }
    }
    
    return Jack__unfinished.defaultLevel
  }
  
  init(scope: String, level: Int? = nil) {
    precondition(!scope.isEmpty)
    
    self.scope = scope
    if let level = level {
      Jack__unfinished.scopeLevels[scope] = level
    }
  }
  
}
