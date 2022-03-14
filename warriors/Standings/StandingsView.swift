//
//  ScheduleView.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

struct StandingsView: View {

    @State private var rosterTeamID: Int?
    @State private var scoresTeamID: Int?
    @State private var scheduleTeamID: Int?
    @ObservedObject var viewModel: StandingsViewModel

    private let seasonID: Int
    private let divisionID: Int

    init(seasonID: Int, divisionID: Int) {
        self.seasonID = seasonID
        self.divisionID = divisionID
        viewModel = StandingsViewModel(seasonID: seasonID, divisionID: divisionID)
    }

    var body: some View {
        ZStack {
            mainList
                .opacity(viewModel.status == .loaded ? 1.0 : 0.0)

            if viewModel.status == .loading {
                ProgressView()
            }

            if case .failedToLoad(let error) = viewModel.status {
                VStack(spacing: 10) {
                    Text(error.localizedDescription)

                    Button(
                        action: {
                            Task {
                                await viewModel.refresh()
                            }
                        },
                        label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    )
                }
            }
        }
        .navigationTitle("Standings")
        .task(id: viewModel) {
            //print("[DEBUG] refreshing StandingsViewModel in .task{} \(viewModel.status)")

            guard viewModel.status != .loaded else { return }
            await viewModel.refresh()
        }
    }

    private var mainList: some View {
        List {
            Section(header: StandingsHeaderView()) {

                ForEach(viewModel.teams) { team in

                    ZStack(alignment: .leading) {
                        NavigationLink(
                            destination: RosterView(seasonID: seasonID, teamID: team.id, teamName: team.name),
                            tag: team.id,
                            selection: $rosterTeamID
                        ) {
                            EmptyView()
                        }
                        .opacity(0)

                        NavigationLink(
                            destination: ScoresView(seasonID: seasonID, divisionID: divisionID, teamID: team.id),
                            tag: team.id,
                            selection: $scoresTeamID) {
                                EmptyView()
                        }
                        .opacity(0)

                        NavigationLink(
                            destination: ScheduleView(seasonID: seasonID, divisionID: divisionID, teamID: team.id),
                            tag: team.id,
                            selection: $scheduleTeamID) {
                            EmptyView()
                        }
                        .opacity(0)

                        StandingsTeamView(team: team)
                    }
                    .contextMenu {
                        Button("Roster") {
                            showRoster(for: team.id)
                        }
                        Button("Scores") {
                            showScores(for: team.id)
                        }
                        Button("Schedule") {
                            showSchedule(for: team.id)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            Task {
                await viewModel.refresh()
            }
        }
    }

    private func showRoster(for teamID: Int) {
        rosterTeamID = teamID
    }

    private func showScores(for teamID: Int) {
        scoresTeamID = teamID
    }

    private func showSchedule(for teamID: Int) {
        scheduleTeamID = teamID
    }
}
