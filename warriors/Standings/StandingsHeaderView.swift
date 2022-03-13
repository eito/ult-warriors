//
//  StandingsHeaderView.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

struct StandingsHeaderView: View {

    var body: some View {
        HStack {
            Text("TEAM")

            Spacer()

            Text("W")
                .frame(width: 15.0)
            Text("L")
                .frame(width: 15.0)
            Text("SOL")
                .frame(width: 30.0)
            Text("PTS")
                .frame(width: 30.0)
            Text("GF")
                .frame(width: 20.0)
            Text("GA")
                .frame(width: 20.0)
            Text("PIM")
                .frame(width: 25.0)
        }
        .font(.footnote.weight(.semibold))
    }
}

