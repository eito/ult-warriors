//
//  GameDetailView.swift
//  Warriors
//
//  Created by Eric Ito on 3/14/22.
//

import Foundation
import SwiftUI

struct GameDetailView: View {

    @ObservedObject var viewModel: GameDetailViewModel
    @State var shouldShowSummaryInSafari = false

    init(game: ScheduleResponse.Game) {
        viewModel = GameDetailViewModel(game: game)
    }

    var body: some View {

        ZStack {

            VStack {
                if let boxScore = viewModel.boxScore {
                    BoxScoreView(boxScore: boxScore)
                }

                Picker("", selection: $viewModel.selectedSegmentIndex) {
                    Text(viewModel.homeTeamName).tag(2)
                    Text("Summary").tag(0)
                    Text(viewModel.awayTeamName).tag(3)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .disabled(viewModel.homeTeamViewModel == nil || viewModel.awayTeamViewModel == nil)
    //
    //            Spacer()

                if viewModel.selectedSegmentIndex == 2, let homeTeamViewModel = viewModel.homeTeamViewModel {
                    TeamView(viewModel: homeTeamViewModel)
                } else if viewModel.selectedSegmentIndex == 3, let awayTeamViewModel = viewModel.awayTeamViewModel {
                    TeamView(viewModel: awayTeamViewModel)
                } else if viewModel.selectedSegmentIndex == 0, let summaryViewModel = viewModel.summaryViewModel {
                    SummaryView(viewModel: summaryViewModel)
                }
            }
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
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    shouldShowSummaryInSafari.toggle()
                }) {
                    Image(systemName: "safari")
                }
            }
        }
        .sheet(isPresented: $shouldShowSummaryInSafari) {
            SafariView(url: URL(string: "https://the-rinks-great-park-ice.kreezee-sports.com/scores/game-\(viewModel.id)")!)
        }
        .task {
            await viewModel.refresh()
        }
    }
}
