//
//  ScheduleView.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI
import SafariServices

struct ScoresView: View {

    @ObservedObject var viewModel: ScoresViewModel
    @State var selectedGame: ScheduleResponse.Game?

    init(seasonID: Int, divisionID:Int, teamID: Int) {
        viewModel = ScoresViewModel(seasonID: seasonID, divisionID: divisionID, teamID: teamID)
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
//                        NavigationLink(destination: GameDetailView(game: game)) {
                            GameScoreView(game: game)
                                .frame(height: 80)
                                .onTapGesture {
                                    selectedGame = game
                                }
//                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Scores")
        } onRefresh: {
            await viewModel.refresh()
        }
        .sheet(item: $selectedGame) { game in
//            Text("\(game.id)")
            
            SafariView(url: URL(string: "https://the-rinks-great-park-ice.kreezee-sports.com/scores/game-\(game.id)")!)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        return
    }
}

struct GameScoreView: View {

    let game: ScheduleResponse.Game

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(Color(.secondarySystemFill))

            VStack(spacing: 8) {

                gameStatus

                HStack {
                    teamNames

                    Spacer()

                    teamScores
                }
            }
            .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 16.0))
        }
    }

    private var gameStatus: some View {
        HStack {
            Text(game.dateString)
            Spacer()
            Text(game.status)
        }
        .font(.footnote)
        .foregroundColor(.secondary)
    }

    private var teamNames: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text("\(game.awayTeamName)")
                .fontWeight(game.isAwayTeamWinner ? .semibold : .regular)
                .foregroundColor(game.isAwayTeamWinner ? .primary : .secondary)

            Text("\(game.homeTeamName)")
                .fontWeight(game.isHomeTeamWinner ? .semibold : .regular)
                .foregroundColor(game.isHomeTeamWinner ? .primary : .secondary)
        }
        .font(.footnote)
        .lineLimit(1)
    }

    private var teamScores: some View {
        VStack(alignment: .trailing, spacing: 4.0) {
            Text("\(game.awayScore)")
                .fontWeight(game.isAwayTeamWinner ? .semibold : .regular)
                .foregroundColor(game.isAwayTeamWinner ? .primary : .secondary)

            Text("\(game.homeScore)")
                .fontWeight(game.isHomeTeamWinner ? .semibold : .regular)
                .foregroundColor(game.isHomeTeamWinner ? .primary : .secondary)
        }
        .foregroundColor(.secondary)
        .font(.footnote)
    }
}
