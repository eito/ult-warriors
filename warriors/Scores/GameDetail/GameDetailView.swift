//
//  GameDetailView.swift
//  Warriors
//
//  Created by Eric Ito on 3/14/22.
//

import Foundation
import SwiftUI

struct GameDetailView: View {

    @ObservedObject var viewModel: GameDetailViewModel

    init(game: ScheduleResponse.Game) {
        viewModel = GameDetailViewModel(game: game)
    }

    var body: some View {
        Text("game detail view")
            .task {
                await viewModel.refresh()
            }
    }
}
