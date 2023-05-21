//
//  RequiredToyTableCellView.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 5/21/23.
//

//
//  ToyItumListView.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/1/22.
//

import SwiftUI
/*
         image toytype
 
        image toyType ThisItemIsOutAlready
*/

struct RequiredToyTableCellView: View {
    var ds: ToyItemUsed
    let df = KMKDateFormatter()
    
    var textView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("You have this item in the cat patio.")
            }
            Spacer(minLength: 16)
            HStack {
                Text("Since:")
                Spacer()
                Text(self.df.convertTimestampToLabel(from: ds.dateAdded))
                Spacer()
            }
            
        }
        .frame(width: UIScreen.main.bounds.width / 2.75)
    }
    
    var body: some View {
        HStack {
            KMKSwiftUIStyles.i.toyImageForToyType(of: ds.type)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75)
                .padding(.all, 2)
            
            
            Text(ds.type.toString())
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 75)
            
            Spacer()
            
            textView
        }
    }
}

struct RequiredToyTableCellView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            List {
                ZStack {
                    RequiredToyTableCellView(ds: ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .chewytoy, hits: 20))
                }.padding(16)
                
                RequiredToyTableCellView(ds: ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .scratchpost, hits: 20))
            }
            ScrollView {
                
                    RequiredToyTableCellView(ds: ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .chewytoy, hits: 20))
                    RequiredToyTableCellView(ds: ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .scratchpost, hits: 20))
                
            }
            
        }
        
        
    }
}
