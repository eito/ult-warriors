//
//  LeadersView.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

struct LeadersView: View {

    @ObservedObject var viewModel: LeadersViewModel

    init(seasonID: Int, divisionID: Int) {
        viewModel = LeadersViewModel(seasonID: seasonID, divisionID: divisionID)
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
        .navigationTitle("Leaders")
        .task(id: viewModel) {
            guard viewModel.status != .loaded else { return }
            await viewModel.refresh()
        }
    }

    private var mainList: some View {
        List {
//            if selectedPlayerType == .skaters {
                skatersSection
//            } else {
//                goaliesSection
//            }
        }
        .animation(.default, value: viewModel.filterText)
        .searchable(text: $viewModel.filterText)
        .listStyle(.plain)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//
//                Menu {
//                    Picker("", selection: $selectedPlayerType) {
//                        ForEach(PlayerType.allCases, id: \.self) { playerType in
//                            Text("\(playerType.rawValue)")
//                        }
//                    }
//                    .labelsHidden()
//                    .animation(.default, value: selectedPlayerType)
//                    .pickerStyle(InlinePickerStyle())
//
//
//                } label: {
//                    Image(systemName: "line.3.horizontal.decrease.circle")
//                }
//            }
//        }
        .refreshable {
            Task {
                await viewModel.refresh()
            }
        }
    }

//    private var goaliesSection: some View {
//        Section(header: GoaliesHeaderView()) {
//            ForEach(viewModel.goalies) { goalie in
//
//                HStack {
//                    Text("\(goalie.number)")
//                        .frame(width: 25.0)
//
//                    VStack(alignment: .leading, spacing: 5) {
//                        Text(goalie.name)
//
//                        Text(goalie.team)
//                            .foregroundColor(.secondary)
//                    }
//
//                    Spacer()
//
//                    Text("\(goalie.gamesPlayed)")
//                        .frame(width: 20.0)
//                    Text("\(goalie.wins)")
//                        .frame(width: 15.0)
//                    Text("\(goalie.losses)")
//                        .frame(width: 15.0)
//                    Text("\(goalie.otl)")
//                        .frame(width: 30.0)
//                    Text("\(goalie.goalsAgainst)")
//                        .frame(width: 30.0)
//                    Text("\(goalie.gaa)")
//                        .frame(width: 40.0)
//                }
//                .font(.footnote)
//            }
//        }
//    }

    private var skatersSection: some View {
        Section(header: SkatersHeaderView()) {
            ForEach(viewModel.skaters) { player in
                HStack {
//                    Text("#\(player.number)")
//                        .frame(width: 25.0)

                    VStack(alignment: .leading, spacing: 5) {
                        Text(player.name)

                        Text(player.team)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Text("\(player.gamesPlayed)")
                        .frame(width: 20.0)
                    Text("\(player.goals)")
                        .frame(width: 20.0)
                    Text("\(player.assists)")
                        .frame(width: 20.0)
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
