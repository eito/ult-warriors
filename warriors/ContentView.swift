//
//  ContentView.swift
//  warriors
//
//  Created by Eric Ito on 3/11/22.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.warriorsTeamID) var warriorsTeamID
    @Environment(\.currentSeasonID) var currentSeasonID
    @Environment(\.bronzeCentralDivisionID) var bronzeCentralDivisionID


    var body: some View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
