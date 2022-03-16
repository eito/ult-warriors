//
//  BoxScoreHeaderView.swift
//  Warriors
//
//  Created by Eric Ito on 3/16/22.
//

import Foundation
import SwiftUI

struct BoxScoreHeaderView: View {

    var body: some View {
        HStack {
            Text("SCORING")
                .fontWeight(.semibold)

            Spacer()

            Text("1")
                .fontWeight(.semibold)
                .frame(width: 20)
            Text("2")
                .fontWeight(.semibold)
                .frame(width: 20)
            Text("3")
                .fontWeight(.semibold)
                .frame(width: 20)
            Text("F")
                .fontWeight(.semibold)
                .frame(width: 20)
        }
    }
}

