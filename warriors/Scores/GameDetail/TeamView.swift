//
//  TeamView.swift
//  Warriors
//
//  Created by Eric Ito on 3/19/22.
//

import Foundation
import SwiftUI

struct TeamView: View {

    @ObservedObject var viewModel: TeamViewModel

    var body: some View {
        ZStack {

            List {
                skatersSection
            }
            .listStyle(.plain)
        }
        .navigationTitle(viewModel.teamName)
    }

    private func number(player: Skater) -> String {
        if let number = player.number {
            return number.isEmpty ? "--" : number
        } else {
            return "--"
        }
    }

    private var skatersSection: some View {
        Section(header: SkatersHeaderView(statTypes: [.g, .a, .pts, .pim])) {
            ForEach(viewModel.skaters) { player in

                HStack {

                    Text(number(player: player))
                        .font(.footnote)
                        .frame(width: 25, height: 25)

                    Text(player.name)

                    Spacer()

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
