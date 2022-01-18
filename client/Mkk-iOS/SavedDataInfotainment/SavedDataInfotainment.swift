//
//  SavedDataInfotainment.swift
//  SavedDataInfotainment
//
//  Created by Conner M on 9/18/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct CoreDataItemContextViewMedium: View {
    var pictureURL: String
    var breedName: String
    var body: some View {
        Text("text")
    }
}


struct SavedDataInfotainmentEntryView : View {
    var entry: Provider.Entry
//    var items: [Item]
    
    var body: some View {

    Text("hi")
        
    }
}

@main
struct SavedDataInfotainment: Widget {
    let kind: String = "SavedDataInfotainment"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SavedDataInfotainmentEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct SavedDataInfotainment_Previews: PreviewProvider {
    static var previews: some View {
        SavedDataInfotainmentEntryView(entry: SimpleEntry(date:  Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        SavedDataInfotainmentEntryView(entry: SimpleEntry(date:  Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        SavedDataInfotainmentEntryView(entry: SimpleEntry(date:  Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
