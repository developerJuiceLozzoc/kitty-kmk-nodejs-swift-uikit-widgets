//
//  KnobGrabberPopover.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/16/23.
//

import SwiftUI


public extension View {
    func knobby<Content: View>(
        alignment: Alignment = .leading,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder _ content: @escaping () -> Content
    ) -> some View {

        self
        .sheet(isPresented: isPresented) {
            let isMac = kmk_readOsType() == .mac
//            var idk: some View {
//                VStack {
//                    HStack {
//                        Spacer()
//                        RoundedRectangle(cornerRadius: 15)
//                            .frame(width: 50, height: 5)
//                            .foregroundColor(Color("ultra-violet-1").opacity(0.4))
//                        Spacer()
//                    }
//                    .background(Color.clear)
//                    .padding()
//                    content()
//                }
//            }
            
            if isMac {
                ZStack {
                    content()
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "x.square.fill")
                                .foregroundColor(Color("ultra-violet-1"))
                                .onTapGesture {
                                    isPresented.wrappedValue = false
                                }
                                .frame(width: 48, height: 48)
                        }
                        Spacer()
                    }
                }
            } else {
                content()
            }
        }
    }
    
}

public struct KnobGrabberPopover: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
    }
}


struct KnobGrabberPopoverPreview: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct KnobGrabberPopover_Previews: PreviewProvider {
    static var previews: some View {
        KnobGrabberPopoverPreview()
    }
}
