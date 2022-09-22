//
//  DateFormatter+Extensions.swift
//  warriors
//
//  Created by Eric Ito on 9/17/22.
//

import Foundation

extension DateFormatter {
  static let iso8601Partial: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
