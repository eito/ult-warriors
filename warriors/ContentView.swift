//
//  ContentView.swift
//  warriors
//
//  Created by Eric Ito on 3/11/22.
//

import SwiftUI

struct ContentView: View {

    @State var warriorsTeamID: Int = 70496
    @State var currentSeasonID: Int = 11288
    @State var bronzeCentralDivisionID: Int = 11194
    @State var isLoading = false

    var body: some View {
        progressOrContentView
        .task {
            isLoading = true
            do {
                let configuration = try await API.fetchConfiguration()
                warriorsTeamID = configuration.teamID
                currentSeasonID = configuration.seasonID
                bronzeCentralDivisionID = configuration.divisionID
            } catch {
                print("Failed to get the configuration: \(error)")
            }
            isLoading = false
        }
    }

    @ViewBuilder
    var progressOrContentView: some View {
        if isLoading {
            ProgressView()
        } else {
            TabView {
                NavigationView {
                    StandingsView(seasonID: currentSeasonID, divisionID: bronzeCentralDivisionID)
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Standings", systemImage: "list.number")
                }
                .tag(1)

                NavigationView {
                    ScheduleView(seasonID: currentSeasonID, divisionID: bronzeCentralDivisionID, teamID: warriorsTeamID)
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
                .tag(2)

                NavigationView {
                    ScoresView(seasonID: currentSeasonID, divisionID: bronzeCentralDivisionID, teamID: warriorsTeamID)
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Scores", systemImage: "22.square")
                }
                .tag(3)

                NavigationView {
                    LeadersView(seasonID: currentSeasonID, divisionID: bronzeCentralDivisionID)
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Leaders", systemImage: "person.3")
                }
                .tag(4)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
