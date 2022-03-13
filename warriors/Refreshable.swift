//
//  Refreshable.swift
//  warriors
//
//  Created by Eric Ito on 3/12/22.
//

import Foundation
import SwiftUI

struct Refreshable<Content: View>: View {

    var content: Content
    var onRefresh: () async -> Void

    init(@ViewBuilder content: @escaping () -> Content, onRefresh: @escaping () async -> Void) {
        self.content = content()
        self.onRefresh = onRefresh
    }

    var body: some View {

        List {
            content
                .listRowSeparatorTint(.clear)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
        .refreshable {
            await onRefresh()
        }
    }
}


