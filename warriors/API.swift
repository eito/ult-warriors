//
//  API.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation

enum API {

    // NOTE: Some endpoints are not available but they embed the JSON inside
    // the HTML response. Super flaky, but it'll do for now.
    //
    // https://the-rinks-great-park-ice.kreezee-sports.com/scores/game-340257
    // var __gameDetails__ = '{<json>}';
    //
    static func fetchResponse<T: Decodable>(for request: URLRequest, in jsonVariable: String, decodable: T.Type) async throws -> T {

        let (data, _) = try await URLSession.shared.data(for: request)
        guard let string = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "invalid string data", code: 1, userInfo: nil)
        }

        let allLines = string.components(separatedBy: CharacterSet.newlines)

        guard let gameDetailsString = allLines.first(where:  { $0.contains(jsonVariable) }) else {
            throw NSError(domain: "invalid jsonVariable, not found \(jsonVariable)", code: 1, userInfo: nil)
        }

        guard let firstIndex = gameDetailsString.firstIndex(of: "{") else {
            throw NSError(domain: "invalid jsonVariable, could not find {", code: 1, userInfo: nil)
        }
        guard let lastIndex = gameDetailsString.lastIndex(of: "}") else {
            throw NSError(domain: "invalid jsonVariable, could not find }", code: 1, userInfo: nil)
        }

        let range = firstIndex...lastIndex

        let jsonString = String(gameDetailsString[range])
//        print(jsonString)

        guard let jsonData = jsonString.data(using: .utf8) else {
            throw NSError(domain: "failed to convert \(jsonString) to data", code: 1, userInfo: nil)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Partial)
        return try decoder.decode(decodable.self, from: jsonData)
    }

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

// https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/games/346644/statistics
// https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/games/<game-id>/statistics

// player stats for season
// https://kreezeerestapi.trafficmanager.net/api/player/385922/log/season/10991

// https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/players/385922/seasons/statistics

// todo PlayerDetailView
// https://the-rinks-great-park-ice.kreezee-sports.com/players/eric-ito-385922
