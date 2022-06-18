//
//  Tutorials.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 3/27/22.
//

import Foundation
import SwiftUI

typealias TutorialSection = (text: [String], header: String)

struct TutorialLikeView: View {
    var sections: [TutorialSection]
    var body: some View {
        Text("helo world.")
    }
}


protocol TutorialLikeRenderable {
    var sections: [TutorialSection] {get}
    func render() -> TutorialLikeView
}


struct TutorialPopup: View {
    var body: some View {
            List {
                
                Section {
                    Text("This tutorial covers the basics for this screen called The Playground and its contents. It goes over how to interact with the screen and other subscriptions each experience includes.")
                    Text("You can always rewatch this tutorial by clicking the (?) icon in the respective screen.")
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Playground Tutorial")
                }
                
                Section {
                    Text("This playground is designed to interface directly with stray cats, althought they also potentially might be that jealous cat that lives with one of your friends, as well playing with your toys. However ultimately the idea is to meet and greet with new cats as well as to Adopt them ie Saving them on your Local Device")
                    
                } header: {
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "The Playground")
                }
                
                Section {
                    Text("To interact and to continue to have new cats stay waiting in the playground you will need to have toys out for them to play with!")
                    Text("Toys represent some sort of physical interface that allows the human and cat to bond, interact and incentivise the cat to stay around and get adopted.")
                    KMKSwiftUIStyles.i.renderSectionHeader(with: "Basic Actions with Toys")
                    Text("Basic Actions with Toys")
                        .font(.title2)
                        .foregroundColor(Color("radio-button-text"))
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
                            .foregroundColor(Color("radio-button-text"))
                        Spacer()
                    }
                    Text("There is some sort of food in here. It could be wet or dry food if you leave it up to your imagination. However this should have some fresh food in it 24/7 if you would like to feed the cats who hang out near the playground.")
                    Text("In order to replenish the Food Bowl, it is a one finger drag scrubbing gesture. You must swipe your finger left and right to fill the bowl, imagine you are gently shaking the food out into your food bowl.")
                    HStack {
                        Text("Water")
                            .font(.title2)
                            .foregroundColor(Color("radio-button-text"))
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

struct ListTutorialPopup: View {
    var body: some View {
        List {
            Section {
                Text("This screen is where you can view and browse the cats you have collected during your time using the platform. You can filter and view the details of each cat from this screen.")
                Text("You can always rewatch this tutorial by clicking the (?) icon in the respective screen.")
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "List Cats Tutorial")
            }
            
            Section {
                Text("This list represents the cats you have saved in the tab called The Playground. They are persisted on disk inside this App's folder.")
                Text("Cats can be removed by uninstalling the application, and reinstalling it. In the future we may or may not include functionality to delete individual items however we are hesitant because why delete cats when you can just own more of them instead?")
                Text("You can view the details of each kitty by clicking on the table row item, in the future sharing the details of a kitty may be avaiblie, tweets, sms or email.")
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "The list")
            }
            Section {
                Text("Recently Accessed")
                    .font(.title2)
                    .foregroundColor(Color("radio-button-text"))
                Text("When you click a cat and see their details page this is considered an access. So by clicking on a cat multiple times their name gets brought up in this list. so if you have a favorite, keep visiting it often to bring it up closer on this list, and if you wish to view ones you havent seen in awhile, change the sort order to Descending.")
                Text("Recently Adopted")
                    .font(.title2)
                    .foregroundColor(Color("radio-button-text"))
                Text("Similar to recently accessed however it sorts based on the 'Birthday' of said cat.")
                Text("Breed")
                    .font(.title2)
                    .foregroundColor(Color("radio-button-text"))
                Text("Each breed is signified as section header in all caps and is colored by the App Theme, multiple cats of the same breed will be wrapped in the same section.")
                Text("Alphabetical Names")
                    .font(.title2)
                    .foregroundColor(Color("radio-button-text"))
                Text("This sorts by the words you named the cat, and is put all into one section.")
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "The filter")
            }
        }
    }
}

struct NeighborhoodPopup: View {
    var body: some View {
        List {
            Section {
                Text("This tutorial covers this tab, which contains undiscovered breeds near you. To meet these local neighborhood cats you must use a specific items.")
                Text("You can always rewatch this tutorial by clicking the (?) icon in the respective screen.")
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "Neighborhood Tutorial")
            }
            
            Section {
                Text("unlike the scheduled nature of constant kitties coming to random toys, additional specific cats are picked up from here using a combination of magiyks.")
                Text("By coordinating what oppertunities exist here at the moment you can receive particular specimens. Some cats create bonds with certain combinations let just say that.")
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "Adoption Style")
            }
            
            Section {
                Text("In this screen you will be presented with multiple groups of scanned kitties. There has been several spottings of kitties and they have been scanned and identified that they like certan combinations of toys out.")
            } header: {
                KMKSwiftUIStyles.i.renderSectionHeader(with: "How to use")
            }
        }
    }
}

