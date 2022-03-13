//
//  API.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation

enum API {

    static func fetchResponse<T: Decodable>(for request: URLRequest, decodable: T.Type) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: request)

#if DEBUG
//        if let str = String(data: data, encoding: .utf8) {
//            print("[JSON] - json response \(str)")
//        }
#endif
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            print("bad error code")
//            return
//        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Partial)
        return try decoder.decode(decodable.self, from: data)
    }
}

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


//
// roster stats, pass teamID and seasonID https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/teams/70496/players/statistics?&seasonId=10991
//
// leaders
// https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/players/statistics?page=1&pageSize=1000&sortOrder=desc&sortStatId=29&positionType=2&seasonId=10991&divisionId=11194
