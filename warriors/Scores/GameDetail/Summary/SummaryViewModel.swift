//
//  SummaryViewModel.swift
//  Warriors
//
//  Created by Eric Ito on 3/16/22.
//

import Foundation
import SwiftUI

class SummaryViewModel: ObservableObject {

    struct Goal: Identifiable {
        let id: Int
        let scorerName: String
        let teamName: String
        let number: String
        let timeElapsed: String
        let period: Int

        let assist1Name: String?
        let assist2Name: String?

        let isSHG: Bool
        let isPPG: Bool

        var isUnknownScorer: Bool {
            scorerName == "Unknown"
        }

        var formattedAssists: String {
            let allAssisters = [assist1Name, assist2Name].compactMap { $0 }

            if allAssisters.isEmpty {
                return "Unassisted"
            } else if allAssisters.count == 1 {
                return "\(allAssisters.first!)"
            } else {
                return "\(allAssisters.joined(separator: ", "))"
            }
        }
        var formattedTime: String {
//            "\(timeElapsed / 60):\(String(format: "%02d", timeElapsed % 60))"
            timeElapsed.split(separator: ":").suffix(2).joined(separator: ":")
        }
    }

    struct Penalty {
        let name: String
        let teamName: String
        let number: String
        let timeElapsed: String
        let infraction: String
        let duration: String
        let period: Int
    }

    struct GoalsSection: Identifiable {
        let id = UUID()
        let name: String
        let goals: [Goal]
    }

    struct PenaltiesSection: Identifiable {
        let id = UUID()
        let name: String
        let penalties: [Penalty]
    }

    private let goals: [Goal]
    private let penalties: [Penalty]

    @Published var goalSections = [GoalsSection]()
    @Published var penaltySections = [PenaltiesSection]()

    init(goals: [Goal], penalties: [Penalty]) {
        self.goals = goals
        self.penalties = penalties

        let goalMapping = Dictionary(grouping: goals, by: { $0.period })
        let numPeriods = goalMapping.keys.count
        if let firstPeriodGoals = goalMapping[1] {
            let first = GoalsSection(name: "1st Period - Scoring", goals: firstPeriodGoals)
            goalSections.append(first)
        }
        if let secondPeriodGoals = goalMapping[2] {
            let second = GoalsSection(name: "2nd Period - Scoring", goals: secondPeriodGoals)
            goalSections.append(second)
        }
        if let thirdPeriodGoals = goalMapping[3] {
            let third = GoalsSection(name: "3rd Period - Scoring", goals: thirdPeriodGoals)
            goalSections.append(third)
        }
        if numPeriods > 3 {
            print("[DEBUG] OT/SO key: \(goalMapping.keys)")
        }

        let penaltyMapping = Dictionary(grouping: penalties, by: { $0.period })
        let firstPeriodPenalties = penaltyMapping[1] ?? []
        let first = PenaltiesSection(name: "1st Period - Penalties", penalties: firstPeriodPenalties)
        penaltySections.append(first)

        let secondPeriodPenalties = penaltyMapping[2] ?? []
        let second = PenaltiesSection(name: "2nd Period - Penalties", penalties: secondPeriodPenalties)
        penaltySections.append(second)

        let thirdPeriodPenalties = penaltyMapping[3] ?? []
        let third = PenaltiesSection(name: "3rd Period - Penalties", penalties: thirdPeriodPenalties)
        penaltySections.append(third)

    }
}

