//
//  GameView.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

class Foo {}

struct NextGameView: View {
    let game: ScheduleResponse.Game
    let isHome: Bool

    var body: some View {

        ZStack(alignment: .leading) {
//            RoundedRectangle(cornerRadius: 8.0)
//                .foregroundColor(Color(.secondarySystemFill))

            Image(uiImage: UIImage(named: "bg")!)
                .renderingMode(.original)
                .resizable()
                .opacity(0.15)

            VStack(alignment: .leading, spacing: 4.0) {

                HStack {
                    Spacer()
                    Text("Up Next")
                        .fontWeight(.bold)
                        .font(.title2)
                    Spacer()
                }

                Spacer()
                    .frame(height: 10.0)

                HStack {
                    VStack(alignment: .leading) {
                        Text(game.dateString)
                        Text(game.timeString)
                    }
                    .fontWeight(.semibold)

                    Spacer()
                    rinkView
                }
                .foregroundColor(.secondary)
                .font(.footnote)

                Spacer()
                    .frame(height: 10.0)

                VStack(alignment: .leading) {

                    if isHome {
                        Text("vs \(game.awayTeamName)")
                    } else {
                        Text("@ \(game.homeTeamName)")
                    }
                }
                .font(.subheadline)
                .fontWeight(.semibold)
            }
            .padding(.horizontal)
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
