//
//  ScheduleView.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

struct StandingsView: View {

    @ObservedObject var viewModel: StandingsViewModel

    init(seasonID: Int, divisionID: Int) {
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
//                        NavigationLink(
//                            destination: RosterView(team: team),
//                            tag: team.id,
//                            selection: $rosterTeamID
//                        ) {
//                            EmptyView()
//                        }
//                        .opacity(0)

//                        NavigationLink(
//                            destination: ScoresView(teamID: team.id),
//                            tag: team.id,
//                            selection: $scoresTeamID) {
//                                EmptyView()
//                        }
//                        .opacity(0)

//                        NavigationLink(
//                            destination: ScheduleView(teamID: team.id),
//                            tag: team.id,
//                            selection: $scheduleTeamID) {
//                            EmptyView()
//                        }
//                        .opacity(0)

                        StandingsTeamView(team: team)
                    }
                    .contextMenu {
                        Button("Roster") {
//                            showRoster(for: team.id)
                        }
                        Button("Scores") {
//                            showScores(for: team.id)
                        }
                        Button("Schedule") {
//                            showSchedule(for: team.id)
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
}
