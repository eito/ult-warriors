//
//  StandingsTeamView.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

struct StandingsTeamView: View {

    let team: StandingsResponse.Team

    var body: some View {
        HStack {
            Text(team.name)

            Spacer()

            Text("\(team.w)")
                .frame(width: 15.0)
            Text("\(team.l)")
                .frame(width: 15.0)
            Text("\(team.sol)")
                .frame(width: 30.0)
            Text("\(team.pts)")
                .frame(width: 30.0)
            Text("\(team.gf)")
                .frame(width: 20.0)
            Text("\(team.ga)")
                .frame(width: 20.0)
            Text("\(team.pim)")
                .frame(width: 25.0)

        }
        .font(.footnote)
        .frame(height: 60.0)
    }
}
