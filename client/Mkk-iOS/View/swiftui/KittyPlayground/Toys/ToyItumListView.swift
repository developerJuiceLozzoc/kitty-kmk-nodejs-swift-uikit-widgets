//
//  ToyItumListView.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/1/22.
//

import SwiftUI

struct ToyItumListView: View {
    var ds: ToyItemUsed
    let df = KMKDateFormatter()
    var body: some View {
        HStack {
            VStack {
                KMKSwiftUIStyles.i.toyImageForToyType(of: ds.type)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 75)
            }
            Text(ds.type.toString())
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 75)
            
            Spacer()
            VStack {
                HStack {
                    Text("Since:")
                    Spacer()
                    Text(self.df.convertTimestampToLabel(from: ds.dateAdded))
                    Spacer()
                }
                HStack {
                    Text("Times Interacted:")
                       .lineLimit(2)
                       .frame(height: 50)
                    Spacer()
                    Text("\(ds.timesInteracted)")
                    Spacer()
                }
            }
            .frame(width: UIScreen.main.bounds.width / 2.75)
        }
    }
}

struct ToyItumListView_Previews: PreviewProvider {
    static var previews: some View {
        ToyItumListView(ds: ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .chewytoy, hits: 20))
    }
}
