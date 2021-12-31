//
//  SwiftUIKMKSwiftUIStyles.i.swift
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


//name
//value
/*

 Section {
 } header: {
     KMKSwiftUIStyles.i.renderSectionHeader(with: "Personality Traits")
 }
 */
struct EmojiSectionView: View {
    var screenWidth: CGFloat
    var ds: RowCellDataSource
    var body: some View {
            if #available(iOS 15.0, *) {
                if ds.varient == 0 {
                    KMKSwiftUIStyles.i.renderLabelWithEmojis(with: ds.stringValue, label: ds.name, value: ds.value, width: screenWidth)
                        .listRowSeparatorTint(Color("ultra-violet-1"))
                } else if ds.varient == 1 {
                    KMKSwiftUIStyles.i.renderTextWithLabel(with: ds.stringValue, label: ds.name, width: screenWidth)
                    .listRowSeparatorTint(Color("ultra-violet-1"))
                }
            } else {
                if ds.varient == 0 {
                    KMKSwiftUIStyles.i.renderLabelWithEmojis(with: ds.stringValue, label: ds.name, value: ds.value, width: screenWidth)
                } else if ds.varient == 1 {
                    KMKSwiftUIStyles.i.renderTextWithLabel(with: ds.stringValue, label: ds.name, width: screenWidth)
                }
                
            }
        
    }
}

class KMKSwiftUIStyles {
    static let i: KMKSwiftUIStyles = KMKSwiftUIStyles()
    
    private init() {}
    
    func renderDashboardTileBorder() -> some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(
                LinearGradient(
                    gradient: Gradient(colors: [Color("border-gradient-topleft"), Color("border-gradient-bottomright")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing),
                lineWidth: 2)
            .shadow(color: .gray, radius:5, x: 1, y: -1)
    }
    func renderDashboardTileBG() -> some View {
        AngularGradient(gradient: Gradient(colors: [Color("dashboard-tile-bg-gradient-1"), Color("dashboard-tile-bg-gradient-end")]), center: .center)
    }
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
