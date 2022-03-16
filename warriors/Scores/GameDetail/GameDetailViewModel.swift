//
//  GameDetailViewModel.swift
//  Warriors
//
//  Created by Eric Ito on 3/14/22.
//

import Foundation
import SwiftUI

@MainActor
class GameDetailViewModel: ObservableObject {

    let id: Int
    private let game: ScheduleResponse.Game

    @Published var status: Status = .idle

    init(game: ScheduleResponse.Game) {
        id = game.id
        self.game = game
    }

    func refresh() async {

        // fetch homeTeam roster
        // fetch awayTeam roster
        // fetch gameDetails
        //
        do {
            let url = URL(string: "https://the-rinks-great-park-ice.kreezee-sports.com/scores/game-\(game.id)")!

            let request = URLRequest(url: url)

            let response = try await API.fetchResponse(for: request, in: "var __gameDetails__", decodable: GameDetailResponse.self)
//            let response = try await API.fetchResponse(for: request, decodable: GameDetailResponse.self)

            print(response)
            
            status = .loaded
        } catch {

            // HACK: because this is called twice it cancels and temporarily
            // shows the cancelled message
            //
            guard (error as NSError).code != -999 else { return }
            status = .failedToLoad(error)
            print("Error fetching standings: \(error)")
        }
    }
}
