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

struct CoreDataItemContextView: View {
    var pictureURL: String
    var breedName: String
    /*
     * toggles and
     * stars 1 out of 5 stars
     
     
     * 2 ratings as stars, next to each other,
     * if they conflict or something
     */
    var body: some View {
        VStack {
//            Image(uiImage: UIImage(contentsOfFile: pictureURL) ?? UIImage() )
//                .size(width: 90, height: 70)
            
            Rectangle()
                .size(width: 90, height: 70)
            Text("hellow world")
            Spacer()
            
        }
    }
}

struct SavedDataInfotainmentEntryView : View {
    var entry: Provider.Entry
//    var items: [Item]
    
    var body: some View {

        CoreDataItemContextView(pictureURL: "https://placekitten.com/200/200", breedName: "Siameze")
//        VStack {
//            HStack {
//                Text("1")
//                Text("2")
//            }
//            HStack {
//
//                Text("3")
//                Text("4")
//            }
//        }
        
        
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
