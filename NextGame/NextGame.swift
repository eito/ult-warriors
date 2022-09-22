//
//  NextGame.swift
//  NextGame
//
//  Created by Eric Ito on 9/17/22.
//

import WidgetKit
import SwiftUI

//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date())
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date())
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}

struct Provider: TimelineProvider {

    let teamID: Int
    let seasonID: Int
    let divisionID: Int

    init() {
        if let existingDefaults = UserDefaults(suiteName: "group.com.ericito.ult-warriors") {
            print("reading values...")

            teamID = existingDefaults.integer(forKey: "teamID")
            seasonID = existingDefaults.integer(forKey: "seasonID")
            divisionID = existingDefaults.integer(forKey: "divisionID")

            print("tid: \(teamID)\nsid: \(seasonID)\ndid: \(divisionID)")
        } else {
            teamID = -1
            seasonID = -1
            divisionID = -1
        }
    }

    func placeholder(in context: Context) -> GameEntry {
        GameEntry(game: nil, isHome: false, date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (GameEntry) -> ()) {

        print("ASKED TO getSnapshot")
        Task {
            print("getting next game...")
            let game = try await API.fetchNextGame(forTeamID: teamID, seasonID: seasonID)
            print("got next game...")
            let entry = GameEntry(game: game, isHome: game?.homeTeamID == teamID,  date: Date())
            print("sending next game...")
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {


//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = GameEntry(game: nil, date: entryDate)
//            entries.append(entry)
//        }
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)

        Task {
            var entries: [GameEntry] = []
            print("getting next game...")
            let game = try await API.fetchNextGame(forTeamID: teamID, seasonID: seasonID)
            print("got next game...")
            let entry = GameEntry(game: game, isHome: game?.homeTeamID == teamID, date: Date())
            print("sending next game...")
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct GameEntry: TimelineEntry {
    let game: ScheduleResponse.Game?
    let isHome: Bool
    let date: Date
}

struct NextGameEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if let game = entry.game {
            NextGameView(game: game, isHome: entry.isHome)
        } else {
            VStack(alignment: .center, spacing: 4.0) {
                
                HStack {
                    Spacer()
                    Text("Up Next")
                        .fontWeight(.bold)
                        .font(.title2)
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 10.0)
                
                Text("No scheduled games :(")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
}

@main
struct NextGame: Widget {
    let kind: String = "NextGame"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NextGameEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct NextGame_Previews: PreviewProvider {
    static var previews: some View {
        NextGameEntryView(entry: GameEntry(game: nil, isHome: false, date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
