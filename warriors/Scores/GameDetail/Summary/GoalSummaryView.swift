//
//  GoalSummaryView.swift
//  Warriors
//
//  Created by Eric Ito on 3/16/22.
//

import Foundation
import SwiftUI

struct GoalSummaryView: View {

    let goal: SummaryViewModel.Goal

    var body: some View {
        HStack {

            TeamAvatarView(team: goal.teamName)

            VStack(alignment: .leading, spacing: 4.0) {
                HStack {
                    Text("\(goal.scorerName)")
                        .fontWeight(.semibold)

                    if goal.isPPG {
                        Text("PPG")
                            .fontWeight(.semibold)
                            .font(.footnote)
                            .foregroundColor(.red)
                    } else if goal.isSHG {
                        Text("SHG")
                            .fontWeight(.semibold)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }

                if !goal.isUnknownScorer {
                    Text("\(goal.formattedAssists)")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
            }

            Spacer()

            VStack {
                Text("\(goal.formattedTime)")
                    .foregroundColor(.secondary)
                    .font(.footnote)
                Spacer()
            }
        }
    }
}
