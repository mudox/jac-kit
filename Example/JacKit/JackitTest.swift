//
//  JackitTest.swift
//  JacKit_Example
//
//  Created by Mudox on 19/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import JacKit
import Fakery

fileprivate let jack = Jack.with(levelOfThisFile: .verbose)

struct JacKitTest {

  let weights = [
    ("error", 7),
    ("warning", 9),
    ("info", 16),
    ("debug", 30),
    ("verbose", 10)
  ]

  lazy var totalWeight: Int = {
    return weights.reduce(0) { $0 + $1.1 }
  }()

  lazy var upperBounds: [Int] = {
    return weights.reduce([Int]()) { (sum: [Int], w: (String, Int)) -> [Int] in
      return sum + [((sum.last ?? 0) + w.1)]
    }
  }()

  mutating func level() -> String {
    let dice = Int(arc4random()) % totalWeight
    for i in 0..<5 {
      if dice < upperBounds[i] {
        return weights[i].0
      }
    }
    return "debug"
  }

  func subsystem() -> Jack.Subsystem {
    let pool: [Jack.Subsystem] = [.app, .fileFunction, .custom("custom.subsystem.\(arc4random() % 7)")]
    return pool[Int(arc4random() % 3)]
  }
  
  let faker = Faker()

  func message() -> String {
    var lines = [String]()
    for i in 1...(1 + arc4random() % 7) {
      lines.append("message line #\(i)")
    }
    return lines.joined(separator: "\n")
  }

  mutating func test() {
    while true {
      let minInterval = 0.03
      let interval = Double(arc4random() % 13) * 0.04
      Thread.sleep(forTimeInterval: minInterval + Double(arc4random() % 9) * interval)

      let s = subsystem()
      let m = message()

      switch level() {
      case "error": jack.error(m, from: s)
      case "warning": jack.warn(m, from: s)
      case "info": jack.info(m, from: s)
      case "debug": jack.debug(m, from: s)
      default:
        jack.verbose(m, from: s)
      }
    }
  }
}

