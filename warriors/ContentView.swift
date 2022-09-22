//
//  ContentView.swift
//  warriors
//
//  Created by Eric Ito on 3/11/22.
//

import SwiftUI

struct ContentView: View {

    @AppStorage("teamID") var warriorsTeamID = -1
    @AppStorage("seasonID") var currentSeasonID = -1
    @AppStorage("divisionID") var bronzeCentralDivisionID = -1

    @State var isLoading = false

    var body: some View {
        progressOrContentView
        .task {

//            if let existingDefaults = UserDefaults(suiteName: "group.com.ericito.ult-warriors") {
//                print("reading values...")
//
//                let teamID = existingDefaults.integer(forKey: "teamID")
//                let seasonID = existingDefaults.integer(forKey: "seasonID")
//                let divisionID = existingDefaults.integer(forKey: "divisionID")
//
//                print("tid: \(teamID)\nsid: \(seasonID)\ndid: \(divisionID)")
//            }
            
            isLoading = true

            defer {
                isLoading = false
            }

            do {
                let configuration = try await API.fetchConfiguration()

                guard
                    warriorsTeamID != configuration.teamID &&
                        currentSeasonID != configuration.seasonID &&
                        bronzeCentralDivisionID != configuration.divisionID
                else {
                    return
                }

                warriorsTeamID = configuration.teamID
                currentSeasonID = configuration.seasonID
                bronzeCentralDivisionID = configuration.divisionID

                if let defaults = UserDefaults(suiteName: "group.com.ericito.ult-warriors") {
                    print("setting values...")
                    defaults.set(warriorsTeamID, forKey: "teamID")
                    defaults.set(currentSeasonID, forKey: "seasonID")
                    defaults.set(bronzeCentralDivisionID, forKey: "divisionID")
                }

                if let game = try await API.fetchNextGame(forTeamID: warriorsTeamID, seasonID: currentSeasonID) {
                    print("Found next game: \(game)")
                }
            } catch {
                print("Failed to get the configuration: \(error)")
            }
        }
    }

    @ViewBuilder
    var progressOrContentView: some View {
        if isLoading && (warriorsTeamID == -1) {
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
