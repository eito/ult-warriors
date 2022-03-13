//
//  GameView.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

struct GameView: View {
    let game: ScheduleResponse.Game

    var body: some View {

        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(Color(.secondarySystemFill))

            VStack(alignment: .leading, spacing: 4.0) {
                HStack {
                    Text("\(game.dateString) · \(game.timeString)")

                    Spacer()

                    rinkView
                }
                .foregroundColor(.secondary)
                .font(.footnote)

                VStack(alignment: .leading, spacing: 4.0) {
                    Text(game.awayTeamName)
                    Text(game.homeTeamName)
                }
                .font(.footnote)
            }
            .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
//            .border(.green, width: 1.0)
        }
    }

    private var rinkView: some View {
        ZStack {
          Circle()
                .stroke(.secondary, lineWidth: 2)

            Text("\(game.rinkNumber)")
                .font(.footnote)
        }
        .frame(width: 20, height: 20)
    }
}
