//
//  LeadersViewModel.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class LeadersViewModel: ObservableObject {

    private let id = UUID()
    private let seasonID: Int
    private let divisionID: Int

    @Published var filterText = ""
    private var subscriptions = Set<AnyCancellable>()

    @Published var status: Status = .idle

    private var allSkaters = [Skater]()
    @Published var skaters = [Skater]()

    init(seasonID: Int, divisionID: Int) {
        self.seasonID = seasonID
        self.divisionID = divisionID

        $filterText
            .sink { newValue in
                self.updateSkaters(with: newValue)
//                self.updateGoalies(with: newValue)
            }
            .store(in: &subscriptions)
    }

    private func updateSkaters(with filterText: String) {

        if filterText.isEmpty {
            skaters = allSkaters
        } else {
            skaters = allSkaters.filter {
                let name = $0.name.lowercased()
                let team = $0.team.lowercased()
                let text = filterText.lowercased()
                return name.contains(text) || team.contains(text)
            }
        }
    }

    func refresh() async {
        status = .loading

        do {
            let url = URL(string: "https://the-rinks-great-park-ice.kreezee-sports.com/api/v2/solutions/20151/players/statistics?page=1&pageSize=1000&sortOrder=desc&sortStatId=29&positionType=2&seasonId=\(seasonID)&divisionId=\(divisionID)")!

            let request = URLRequest(url: url)

            let response = try await API.fetchResponse(for: request, decodable: LeadersResponse.self)

            allSkaters = response.results.map { Skater(result: $0) }
            updateSkaters(with: filterText)

            status = .loaded
        } catch {
            // HACK: because this is called twice it cancels and temporarily
            // shows the cancelled message
            //
            guard (error as NSError).code != -999 else { return }
            status = .failedToLoad(error)
            print("Error fetching leaders: \(error)")
        }
    }
}

extension LeadersViewModel: Equatable {
    nonisolated static func ==(lhs: LeadersViewModel, rhs: LeadersViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
