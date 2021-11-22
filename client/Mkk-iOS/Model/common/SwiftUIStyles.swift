//
//  SwiftUIStyles.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/21/21.
//

import Foundation
import SwiftUI

func doubleDateToString(from date: Double) -> String{
    let birthday = Date(timeIntervalSince1970: date)
    let df = DateFormatter()
    df.dateFormat = "MMM dd, yyyy"
    return df.string(from: birthday)
}


func parseTemperament(with str: String) -> [[String]] {
    var i: Int = 0
    var traits: [[String]] = [[]]
    str.split(separator: ",").forEach { substr in
        if traits[i].count == 3 {
            traits.append([])
            i += 1
        }
        traits[i].append(String(substr))
        
    }
    return traits
}

struct TemperamentView: View {
    var traits: [[String]]
    var body: some View {
        VStack {
            ForEach(0..<traits.count){ i in
                HStack{
                    ForEach(0..<traits[i].count){ j in
                        Text(traits[i][j])
                            .foregroundColor(Color("ultra-violet-1"))
                            .padding(5)
                            .background(LinearGradient(colors: [Color("list-kitty-name-gradient-end-color"),Color.purple], startPoint: .trailing, endPoint: .leading))
                        
                    }
                }
                
            }
        }.frame(maxWidth: .infinity)
    }
}

struct EmojiSectionView: View {
    var stats: KittyBreed
    var styles = SwiftUIStyles()
    var screenWidth: CGFloat
    var body: some View {
        Section {
            if #available(iOS 15.0, *) {
                styles.renderTextWithLabel(with: "\(stats.life_span) years", label: "Life Span", width: screenWidth)
                .listRowSeparatorTint(Color("ultra-violet-1"))
                
                styles.renderLabelWithEmojis(with: "🧠", label: "Intelligence", value: stats.intelligence, width: screenWidth)
                    .listRowSeparatorTint(Color("ultra-violet-1"))
                styles.renderLabelWithEmojis(with: "⚡️", label: "Energy Lvl", value: stats.energy_level, width: screenWidth)
                    .listRowSeparatorTint(Color("ultra-violet-1"))
                styles.renderLabelWithEmojis(with: "🧟‍♂️", label: "Stranger Friendly", value: stats.stranger_friendly, width: screenWidth)
                    .listRowSeparatorTint(Color("ultra-violet-1"))
                styles.renderLabelWithEmojis(with: "🐶", label: "Dog Friendly", value: stats.dog_friendly, width: screenWidth)
                    .listRowSeparatorTint(Color("ultra-violet-1"))
                
            } else {
                styles.renderTextWithLabel(with: "\(stats.life_span) years", label: "Life Span", width: screenWidth)
                styles.renderLabelWithEmojis(with: "🧠", label: "Intelligence", value: stats.intelligence, width: screenWidth)
                styles.renderLabelWithEmojis(with: "⚡️", label: "Energy Lvl", value: stats.energy_level, width: screenWidth)
                styles.renderLabelWithEmojis(with: "🧟‍♂️", label: "Stranger Friendly", value: stats.stranger_friendly, width: screenWidth)
                styles.renderLabelWithEmojis(with: "🐶", label: "Dog Friendly", value: stats.dog_friendly, width: screenWidth)
            }
        } header: {
            styles.renderSectionHeader(with: "Personality Traits")
        }
    }
}

class SwiftUIStyles {
    func renderSubmitButtonBG() -> some View {
        return LinearGradient(colors: [Color("submit-green"),Color("submit-end")], startPoint: .leading, endPoint: .trailing)
    }
    func renderLabelWithEmojis(with emoji: String,label: String,value: Int,width: CGFloat) -> some View {
        return HStack {
            Text(label)
                .foregroundColor(Color("form-label-color"))
                .font(.system(.body))
            Spacer()
            Text(String(repeating: emoji, count: value))
                    .font(.system(.title3))
                    .frame(width: width * 0.55)

        }.frame(maxWidth: .infinity)
    }
    func renderImportantTextWithLabel(with text: String, label: String, width: CGFloat) -> some View {
        return HStack {
            Text(label)
                .foregroundColor(Color("form-label-color"))
                .font(.system(.body))
            Spacer()
            Text(text)
                .font(.system(.title3))
                .frame(width: width * 0.6)
        }.frame(maxWidth: .infinity)
        
    }
    func renderTextWithLabel(with text: String, label: String, width: CGFloat) -> some View {
        return HStack {
            Text(label)
                .foregroundColor(Color("form-label-color"))
                .font(.system(.body))
            Spacer()
            Text(text)
                .font(.system(.caption))
                .frame(width: width * 0.44)
        }.frame(maxWidth: .infinity)
    }
    func renderSectionHeader(with title: String) -> some View {
        return Text(title)
            .foregroundColor(renderSeperator())
            .font(.system(.title3))
    }
    func renderKittyName(with name: String) -> some View {
        return Text(name)
    }
    func renderSeperator() -> Color {
       return Color("ultra-violet-1")
    }
    func renderListRowBG() -> some View {
        return LinearGradient(colors: [Color("list-kitty-name-gradient-end-color"),Color.purple], startPoint: .trailing, endPoint: .leading)
    }

}
