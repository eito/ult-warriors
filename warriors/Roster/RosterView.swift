//
//  RosterView.swift
//  Warriors
//
//  Created by Eric Ito on 3/13/22.
//

import Foundation
import SwiftUI

struct RosterView: View {

    @ObservedObject var viewModel: RosterViewModel

    init(seasonID: Int, teamID: Int, teamName: String) {
        viewModel = RosterViewModel(seasonID: seasonID, teamID: teamID, teamName: teamName)
    }

    var body: some View {
        ZStack {

            List {
                skatersSection
            }
            .listStyle(.plain)
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
        .navigationTitle(viewModel.teamName)
        .refreshable {
            await viewModel.refresh()
        }
        .task(id: viewModel) {
            guard viewModel.status != .loaded else { return }
            await viewModel.refresh()
        }
    }

    private func number(player: Skater) -> String {
        if let number = player.number {
            return number.isEmpty ? "--" : number
        } else {
            return "--"
        }
    }

    private var skatersSection: some View {
        Section(header: SkatersHeaderView()) {
            ForEach(viewModel.skaters) { player in

                HStack {
//                    ZStack {
//                        Circle()
//                            .stroke(.secondary, lineWidth: 2)
//
//                        Text(number(player: player))
//                            .font(.footnote)
//                    }
//                    .frame(width: 25, height: 25)

                    Text(number(player: player))
                        .font(.footnote)
                        .frame(width: 25, height: 25)

                    Text(player.name)

                    Spacer()

                    Text("\(player.gamesPlayed)")
                        .frame(width: 20.0)
                    Text("\(player.goals)")
                        .frame(width: 15.0)
                    Text("\(player.assists)")
                        .frame(width: 15.0)
                    Text("\(player.pts)")
                        .frame(width: 30.0)
                    Text("\(player.pim)")
                        .frame(width: 30.0)
                }
                .font(.footnote)
            }
        }
    }
}
