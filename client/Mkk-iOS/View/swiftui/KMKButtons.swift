//
//  KMKButtons.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/8/22.
//

import SwiftUI

struct KMKLongPressYellow: View {
    @GestureState var isDetectingLongPress = false
    var onLongPress: ()->()
    
    var longPress: some Gesture {
            LongPressGesture(minimumDuration: 1)
                .updating($isDetectingLongPress) { currentState, gestureState,
                        transaction in
                    gestureState = currentState
                    transaction.animation = Animation.easeIn(duration: 0.75)
                }
                .onEnded { finished in
                    if finished {
                        onLongPress()
                    }
                }
        }
    
    var body: some View {
        HStack {
            Text("Clear")
                .foregroundColor(isDetectingLongPress ? Color.white : Color.black)
                .font(.title)
                                 
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .foregroundColor(isDetectingLongPress ? Color("form-label-colorf") : Color.black)
        .background(isDetectingLongPress ? Color("suggesting-yellow") : Color.clear)
        .contentShape(Rectangle())
        .gesture(longPress)
        .animation(.easeOut(duration: 1.0), value: isDetectingLongPress)
        
    }
}

struct BlueButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .font(.headline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
        .contentShape(Rectangle())
        .foregroundColor(configuration.isPressed ? Color("form-label-colorf") : Color.black)
        .background(configuration.isPressed ? Color("suggesting-yellow") : Color.clear)
        .animation(.easeOut(duration: 1.0), value: configuration.isPressed)

        
  }
}

struct KMKButtons_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                Button(action: {print("pressed")})
                {
                    Text("Save")
                }.buttonStyle(BlueButtonStyle())
            }
        }
        
        
    }
}
