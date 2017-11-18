//
//  Pretty.swift
//  Pods
//
//  Created by Mudox on 25/03/2017.
//
//

import Foundation

public func pretty(of subject: Any, name: String? = nil, indent: Int = 2) -> String {
  var lines = ""

  switch subject {

  case let error as NSError:
    var lineList = [
      "- domain     : \(error.domain)",
      "- code       : \(error.code)",
      "- description: \(error.localizedDescription)",
      "- user info  :",
      "\(pretty(of: error.userInfo, indent: indent * 2))",
    ]
    lineList = lineList.map { String(repeating: " ", count: indent) + $0 }
    lines = lineList.joined(separator: "\n")
    break

  default:
    dump(subject, to: &lines, name: name, indent: indent)
  }

  return lines
}
