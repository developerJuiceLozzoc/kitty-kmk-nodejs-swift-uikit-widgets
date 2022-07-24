//
//  KMKButtons.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/8/22.
//

import SwiftUI

struct KMKLongPressYellow: View {
    @GestureState var isDetectingLongPress = false
    var buttonTitle: String
    var onLongPress: () -> Void
    @State var yellowFontState: NetworkState = .idle
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1.5)
                .updating($isDetectingLongPress) { currentState, gestureState,
                        transaction in
                    gestureState = currentState
                    transaction.animation = Animation.easeIn(duration: 0.75)
                }
                .onEnded { finished in
                    print(finished)
                    yellowFontState = finished ? .success : .failed
                    if finished {
                       onLongPress()
                    }
                }
        }
    var titleTextColor: Color {
        switch (yellowFontState,isDetectingLongPress) {
        case (.idle,false):
            return Color.black
        case (.success,false):
            return Color.green
        case (.failed,_):
            return Color.red
        default:
            return Color.white
        }
    }
    var bgColor: Color {
        switch (yellowFontState,isDetectingLongPress) {
        case (.success,true):
            return Color.green
        case (.idle, true):
            return Color("suggesting-yellow")
        default:
            return Color.clear
        }
    }
    var body: some View {
        HStack {
            Text(buttonTitle)
                .foregroundColor(titleTextColor)
                .font(.title)
                                 
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .foregroundColor(isDetectingLongPress ? Color("form-label-color") : Color.black)
        .background(isDetectingLongPress ? Color("suggesting-yellow") : Color.clear )
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
    static var onLongPress: () -> Void = {
        return
    }

    static var previews: some View {
        List {
            Section {
                Button(action: {print("pressed")})
                {
                    Text("Save")
                }.buttonStyle(BlueButtonStyle())
            }
            KMKLongPressYellow(buttonTitle: "cool", onLongPress: onLongPress)
        }
        
        
    }
}
