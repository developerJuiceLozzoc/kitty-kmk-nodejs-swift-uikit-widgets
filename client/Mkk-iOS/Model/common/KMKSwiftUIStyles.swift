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

struct KMKCustomSwipeUp<Content: View>: View {
    var content: () -> Content
    @Binding var gestureActivated: Bool
    @State var gestureInProgress: Bool = false
    
    var body: some View {
        content()
        .frame(height: 100)
        .background(
            KMKSwiftUIStyles.i.renderSelectableTileBG(isSelected: gestureInProgress)
        )
        .overlay(
            KMKSwiftUIStyles.i.renderDashboardTileBorder()
        )
        .onTapGesture {
            gestureInProgress = true
            gestureActivated.toggle()

        }
        .gesture(
            DragGesture()
                .onChanged { g in
                    if !gestureInProgress {
                        gestureInProgress = true
                    }
                }
                .onEnded { g in
                    if g.startLocation.y > g.location.y {
                        gestureActivated.toggle()
                    }
            }
        )
        .onAppear {
            if gestureInProgress {
                gestureInProgress = false
            }
        }
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
    func renderSelectedTile(isSelected: Bool, text: String) -> some View {
        Text(text)
            .frame(width: (UIScreen.main.bounds.width-50)/3, height: (UIScreen.main.bounds.width-50)/3)
            .background(
                KMKSwiftUIStyles.i.renderSelectableTileBG(isSelected: isSelected)
            )
            .overlay (
                KMKSwiftUIStyles.i.renderDashboardTileBorder()
            )
    }
    func renderSelectableTileBG(isSelected: Bool?) -> some View {
        if isSelected == nil || isSelected == false {
            return AngularGradient(gradient: Gradient(colors: [Color.white, Color.white]), center: .center)
        } else {
            return AngularGradient(gradient: Gradient(colors: [Color("dashboard-tile-bg-gradient-1"), Color("dashboard-tile-bg-gradient-end")]), center: .center)
        }
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
    
    func toyImageForToyType(of type: ToyType) -> Image {
        switch type {
        case .chewytoy:
            return Image("toy_chew-toy")
        case .scratchpost:
            return Image("toy_scratching-post")
        case .shinystring:
            return Image("toy_shiny-toy")
        case .yarnball:
            return Image("toy_yarn-ball")
        default:
             return Image("pizza-100")
        }
    }
    
    func renderAlertForType(type: KMKAlertType) -> Alert {
        switch type {
        case .succRegisterForPush:
            return Alert(title: Text("Success"), message: Text("Your preferences have been updated."))
        case .failedRegisterForPush:
            return Alert(title: Text("Error Occured Scheduling Notifications"), message: Text("Sorry but the ether has failed to persist your request for notifications."))
        case .removeNotifFailureForeground:
            return Alert(title: Text("An Error occured!"), message: Text("Please try to manully reset the play ground with the gesture again."))
        case .removeNotifFailureBackground:
            return Alert(title: Text("Sorry to interrupt however there is an Error."), message: Text("We tried updating your preferences, but failed, please try again manually using the Clean Up button in the toy menu"))
        case .removeNotifSuccess:
            return Alert(title: Text("You have now cleaned up"), message: Text("Now that all the toys are removed, you will no longer receive notifications ie no more kitties daily."))
        }
    }
    

}
