//
//  SummaryView.swift
//  Warriors
//
//  Created by Eric Ito on 3/16/22.
//

import Foundation
import SwiftUI

struct SummaryView: View {

    @ObservedObject var viewModel: SummaryViewModel

//    init(viewModel: SummaryViewModel) {
//        viewModel = SummaryViewModel(goals: goals, penalties: penalties)
//    }

    var body: some View {
        List {
            ForEach(viewModel.goalSections) { section in
                Section(section.name) {
                    ForEach(section.goals) { goal in
                        GoalSummaryView(goal: goal)
                            .frame(height: 50.0)
                    }
                }
            }

//            ForEach(viewModel.penaltySections) { section in
//                Section(section.name) {
//
//                    if !section.penalties.isEmpty {
//                        ForEach(section.penalties) { penalty in
//                            PenaltySummaryView(penalty: penalty)
//                                .frame(height: 50.0)
//                        }
//                    } else {
//                        Text("None")
//                            .foregroundColor(.secondary)
//                    }
//                }
//            }
        }
    }
}
