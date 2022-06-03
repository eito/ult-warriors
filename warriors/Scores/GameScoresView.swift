//
//  GameScoresView.swift
//  Warriors
//
//  Created by Eric Ito on 6/3/22.
//

import Foundation
import SwiftUI

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
