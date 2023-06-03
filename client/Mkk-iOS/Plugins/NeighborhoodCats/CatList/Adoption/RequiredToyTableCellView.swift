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



struct RequiredToyTableCellView: View {
    var ds: ToyItemUsed
    let df = KMKDateFormatter()
    
    
    var isSelected: Bool {
        ds.dateAdded != 0
    }
    
    var textView: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 16)
            HStack {
                Spacer()
                Text("~\(self.df.describeDate(ds.dateAdded))")
                Spacer()
            }
            
        }
        .frame(width: UIScreen.main.bounds.width / 2.75)
    }
    var backgroundColor: Color {
        isSelected ?  Color.purple.opacity(0.05) : .clear
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
            if isSelected {
                textView
            }
        }
        .padding(16)
        .overlay {
            if isSelected {
                Rectangle()
                    .stroke(lineWidth: 4)
                    .fill(Color("ultra-violet-1"))
            }
            
        }
        .background(backgroundColor)
        .padding(.horizontal)
    }
}

struct RequiredToyTableCellView_Previews: PreviewProvider {
        
    static var previews: some View {
        VStack(spacing: 16) {
            
            ScrollView {
                RequiredToyTableCellView(ds: ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .chewytoy, hits: 20))
                
                    stylyndivider()
                
                RequiredToyTableCellView(ds: ToyItemUsed(dateAdded: 0.0, type: .scratchpost, hits: 20))
                RequiredToyTableCellView(ds: ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .scratchpost, hits: 20))
                
            }
            
        }
        
        
    }
}


public struct stylyndivider: View {
    public var body: some View {
        VStack {
            
        }
    }
}
