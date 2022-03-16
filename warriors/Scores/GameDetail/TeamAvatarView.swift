//
//  TeamAvatarView.swift
//  Warriors
//
//  Created by Eric Ito on 3/16/22.
//

import Foundation
import SwiftUI

struct TeamAvatarView: View {

    private let characters: String

    init(team: String) {
        let firstLetters = team.components(separatedBy: " ").filter { $0.count > 1 }.map { $0.prefix(1)}.joined()
        characters = String(firstLetters)
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(UIColor.secondarySystemFill))

            Text(characters)
        }
        .frame(width: 44.0)
    }
}

