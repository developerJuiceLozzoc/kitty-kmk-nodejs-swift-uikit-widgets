//
//  SwiftUIKMKSwiftUIStyles.i.swift
//  Mkk-iOS
//
//  Created by Conner M on 11/21/21.
//

import Foundation
import SwiftUI

struct StateableButton<Content>: ButtonStyle where Content: View {
    var change: (Bool) -> Content
    
    func makeBody(configuration: Configuration) -> some View {
        return change(configuration.isPressed)
    }
}

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

struct ListTutorialPopup: View {
    var body: some View {
        List {
            Section {
                Text("This screen is where you can view and browse the cats you have collected during your time using the platform. You can filter and view the details of each cat from this screen.")
                Text("You can always rewatch this tutorial by using the control in the Main Menu tab of the application.")
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "List Cats Tutorial")
            }
            
            Section {
                Text("This list represents the cats you have saved in the tab called The Playground. They are persisted on disk inside this App's folder.")
                Text("Cats can be removed by uninstalling the application, and reinstalling it. In the future we may or may not include functionality to delete individual items however we are hesitant because why delete cats when you can just own more of them instead?")
                Text("Recently Accessed")
                    .font(.title2)
                Text("When you click a cat and see their details page this is considered an access. The application keeps track of 7 or so cats at a time in this list. So by clicking on a cat multiple times their name gets brought up in the list, otherwise it will disappear into the sort by breed list.")
                Text("Recently Adopted")
                    .font(.title2)
                Text("Similar to recently accessed however it sorts based on the 'Birthday' of said cat, and takes the top 10 in the list")
                Text("Breed")
                    .font(.title2)
                Text("Each breed is signified as section header in all caps and is colored by the App Theme, multiple cats of the same breed may be wrapped in the same section.")
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "The list")
            }
        }
    }
}


struct TutorialPopup: View {
    var body: some View {
            List {
                
                Section {
                    Text("This tutorial covers the basics for this screen called The Playground and its contents. It goes over how to interact with the screen and other subscriptions each experience includes.")
                    Text("You can always rewatch this tutorial by using the control in the Main Menu tab of the application.")
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Playground Tutorial")
                }
                
                Section {
                    Text("This playground is designed to interface directly with stray cats, althought they also potentially might be that jealous cat that lives with one of your friends, as well playing with your toys. However ultimately the idea is to meet and greet with new cats as well as to Adopt them ie Saving them on your Local Device")
                    
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "The Playground")
                }
                
                Section {
                    Text("To interact and to continue to have new cats stay waiting in the playground you will need to have toys out for them to play with")
                    Text("Toys represent some sort of physical interface that allows the human and cat to bond, interact and incentivise the cat to stay around and get adopted.")
                    Text("Basic Actions with Toys")
                        .font(.title2)
                    Text("When you bring some toys and interactables outside and set them up for cats to play with, this is how notifications get scheduled. So by setting up toys and leaving them out, a notification will be scheduled.")
                    Text("If you leave toys out for multiple days then you will continue to receive notifications daily")
                    Text("You can either explicitely clear your scheduled notifications by the long press Clear button, or by manually putting away all your toys.")
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Toys")
                }
                
                Section {
                    Text("Food and water are important to keeping a family stay alive as well as provide a reason for cats to hang out in a particular area. If you continue to keep the food and water out, then the cat will always come back to greet you. If the food and water bowls run out the existing cats waiting may leave to survive elsewhere. ")
                        .lineLimit(20)
                    HStack {
                        Text("Food")
                            .font(.title2)
                        Spacer()
                    }
                    Text("There is some sort of food in here. It could be wet or dry food if you leave it up to your imagination. However this should have some fresh food in it 24/7 if you would like to feed the cats who hang out near the playground.")
                    Text("In order to replenish the Food Bowl, it is a one finger drag scrubbing gesture. You must swipe your finger left and right to fill the bowl, imagine you are gently shaking the food out into your food bowl.")
                    HStack {
                        Text("Water")
                            .font(.title2)
                        Spacer()
                    }
                    Text("Only the most fresh distilled water availibe here directly for consumption. Nearby there is a water pouring can that used to transfer water into the watering bowl.")
                    Text("This water is chilled in the summer and kept slightly above 70 Farenheight in the winter time, as well as added with slight traces of Electrolytes and minerals for taste and hydration.")
                    Text("In order to pour water, you must use two fingers. Gently tap and hold two fingers at the top of the tile, and slowly drag them downards to start filling the bowl. Imagine you are slowly tipping the watering can to fill the bowl.")
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Food and Water")
                }
                
            }
    }
}

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

struct CatListRowItem: View {
    var name: String
    var body: some View {

        HStack {
            if #available(iOS 15.0, *) {
                 Text(name)
                    .listRowSeparatorTint(Color("ultra-violet-1"))
                    .listRowBackground(KMKSwiftUIStyles.i.renderListRowBG())
                    
            } else {
                 Text(name)
                    .listRowBackground(KMKSwiftUIStyles.i.renderListRowBG())
            }
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
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
