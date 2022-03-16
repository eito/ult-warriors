//
//  BoxScoreView.swift
//  Warriors
//
//  Created by Eric Ito on 3/16/22.
//

import Foundation
import SwiftUI

struct BoxScoreView: View {

    let boxScore: BoxScore

    var body: some View {
        VStack(spacing: 4.0) {
            BoxScoreHeaderView()
                .font(.footnote)

            HStack {
                Text("\(boxScore.homeTeamName)")

                Spacer()

                Text("\(boxScore.homeGoalsByPeriod[1] ?? 0)")
                    .frame(width: 20)
                Text("\(boxScore.homeGoalsByPeriod[2] ?? 0)")
                    .frame(width: 20)
                Text("\(boxScore.homeGoalsByPeriod[3] ?? 0)")
                    .frame(width: 20)
                Text("\(boxScore.homeScore)")
                    .frame(width: 20)
            }
            .foregroundColor(.secondary)
            .font(.footnote)

            HStack {
                Text("\(boxScore.awayTeamName)")

                Spacer()

                Text("\(boxScore.awayGoalsByPeriod[1] ?? 0)")
                    .frame(width: 20)
                Text("\(boxScore.awayGoalsByPeriod[2] ?? 0)")
                    .frame(width: 20)
                Text("\(boxScore.awayGoalsByPeriod[3] ?? 0)")
                    .frame(width: 20)
                Text("\(boxScore.awayScore)")
                    .frame(width: 20)
            }
            .foregroundColor(.secondary)
            .font(.footnote)
        }
        .padding()
    }
}
