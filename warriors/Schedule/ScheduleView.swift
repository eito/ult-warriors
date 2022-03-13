//
//  ScheduleView.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

struct ScheduleView: View {

    @ObservedObject var viewModel: ScheduleViewModel

    init(seasonID: Int, divisionID:Int, teamID: Int) {
        viewModel = ScheduleViewModel(seasonID: seasonID, divisionID: divisionID, teamID: teamID)
    }

    let columns = [
        GridItem(.flexible(minimum: 150, maximum: 300)),
        GridItem(.flexible(minimum: 150, maximum: 300))
    ]

    var body: some View {
        ZStack {
            mainGrid
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
        .task(id: viewModel) {
            guard viewModel.status != .loaded else { return }
            await viewModel.refresh()
        }
    }

    private var mainGrid: some View {
        Refreshable {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.games, id: \.id) { game in
//                        Scheduled
                        GameView(game: game)
                            .frame(height: 80)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Schedule")
        } onRefresh: {
            await viewModel.refresh()
        }
    }
}
