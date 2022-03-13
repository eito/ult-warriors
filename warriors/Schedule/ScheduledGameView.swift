//
//  ScheduledGameView.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

struct ScheduledGameView: View {

    let game: ScheduleResponse.Game

    var body: some View {

        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(Color(.secondarySystemFill))

            VStack(alignment: .leading, spacing: 6.0) {
                HStack {
                    Text(game.dateString)
                    Spacer()
                    Text(game.timeString)
                }
                .foregroundColor(.secondary)
                .font(.footnote)

                Text("Rink \(game.rinkNumber)")
                    .foregroundColor(.secondary)
                    .font(.footnote)

                VStack(alignment: .leading, spacing: 4.0) {
                    Text("\(game.awayTeamName)")
                    Text("\(game.homeTeamName)")
                }
                .font(.footnote)
                .lineLimit(1)
            }
            .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
        }
    }
}
