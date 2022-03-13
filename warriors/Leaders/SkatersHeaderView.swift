//
//  SkatersHeaderView.swift
//  warriors
//
//  Created by Eric Ito on 3/13/22.
//

import Foundation
import SwiftUI

struct SkatersHeaderView: View {

    enum StatType: CaseIterable {
        case gp
        case g
        case a
        case pts
        case pim
    }

    private let statTypes: [StatType]

    init(statTypes: [StatType] = StatType.allCases) {
        self.statTypes = statTypes
    }

    var body: some View {
        HStack {
            Text("SKATERS")

            Spacer()

            if statTypes.contains(.gp) {
                Text("GP")
                    .frame(width: 20.0)
            }

            if statTypes.contains(.g) {
                Text("G")
                    .frame(width: 20.0)
            }

            if statTypes.contains(.a) {
                Text("A")
                    .frame(width: 20.0)
            }

            if statTypes.contains(.pts) {
                Text("PTS")
                    .frame(width: 30.0)
            }

            if statTypes.contains(.pim) {
                Text("PIM")
                    .frame(width: 30.0)
            }
        }
        .font(.footnote.weight(.semibold))
    }
}

