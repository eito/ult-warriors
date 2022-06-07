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

    static func fetchRoster(teamID: Int, seasonID: Int) async throws -> [Skater] {

        let url = URL(string: "https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/teams/\(teamID)/players/statistics?&seasonId=\(seasonID)")!

        let request = URLRequest(url: url)

        let response = try await API.fetchResponse(for: request, decodable: RosterResponse.self)

        let invalidDataError = NSError(domain: "unknown", code: 1, userInfo: nil)
        guard let first = response.playerCategories.first else {
            throw invalidDataError
        }

        var allSkaters = [Skater]()
        for player in first.players {

            guard let goals = player.stats.first(where: { $0.statTypeId == 6 })?.value else { throw invalidDataError }
            guard let assists = player.stats.first(where: { $0.statTypeId == 7 })?.value else { throw invalidDataError }
            guard let pim = player.stats.first(where: { $0.statTypeId == 8 })?.value else { throw invalidDataError }
            guard let gp = player.stats.first(where: { $0.statTypeId == 14 })?.value else { throw invalidDataError }
            guard let ppg = player.stats.first(where: { $0.statTypeId == 26 })?.value else { throw invalidDataError }
            guard let shg = player.stats.first(where: { $0.statTypeId == 27 })?.value else { throw invalidDataError }
            guard let gwg = player.stats.first(where: { $0.statTypeId == 28 })?.value else { throw invalidDataError }
            guard let pts = player.stats.first(where: { $0.statTypeId == 29 })?.value else { throw invalidDataError }

            let skater = Skater(
                teamID: teamID,
                playerID: player.id,
                name: player.name,
                team: player.teamName,
                goals: goals,
                assists: assists,
                pim: pim / 10,
                gamesPlayed: gp,
                ppg: ppg,
                shg: shg,
                gwg: gwg,
                pts: pts,
                number: player.number)
            allSkaters.append(skater)
        }

        return allSkaters.sorted { s1, s2 in
            if s1.pts == s2.pts {
                return s1.goals > s2.goals
            } else {
                return s1.pts > s2.pts
            }
        }

        /*
         sid 6  ------- 5   GOALS
         sid 7  ------- 4   ASSISTS
         sid 8  ------- 20 2 -- PIM
         sid 9
         sid 10 --- 17 SAVES
         sid 11
         sid 12
         sid 13
         sid 14 -------- 5  GP
         sid 15 --- 2 WINS
         sid 16
         sid 17
         sid 18
         sid 19
         sid 20
         sid 21
         sid 22 --- 8 GA
         sid 23 --- 23 SHOTS
         sid 24 --- 72 MIN
         sid 25
         sid 26 ----------- PP
         sid 27 ------------ SHG
         sid 28 ----------- 1 GWG
         sid 29 ----------- 9 PTS
         sid 62 --- 2 WINS?
         sid 29
         sid 30 --- 652 0.652 SV %
         sid 31 ---- 0 0.00  Points Per Game
         sid 32 ---  0 0.00
         sid 33

         */
    }

    static func fetchSchedule(forTeamID teamID: Int, seasonID: Int) async throws -> [ScheduleResponse.Game] {

        let url = URL(string: "https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/seasons/\(seasonID)/schedule")!
        let request = URLRequest(url: url)

        let allGamesResponses = try await API.fetchResponse(for: request, decodable: [ScheduleResponse.GameResponse].self)

        let allGames = allGamesResponses.compactMap { ScheduleResponse.Game(response: $0) }

        var scheduledGames = [ScheduleResponse.Game]()
        for game in allGames.filter({ ($0.homeTeamID == teamID || $0.awayTeamID == teamID) && !$0.isFinal }) {
//                print("\(game.id)  --- \(game.awayTeamName) @ \(game.homeTeamName)")

            scheduledGames.append(game)
        }

        return scheduledGames
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
