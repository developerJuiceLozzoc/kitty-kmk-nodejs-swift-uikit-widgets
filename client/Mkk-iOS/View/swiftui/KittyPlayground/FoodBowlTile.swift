//
//  FoodBowl.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//

import SwiftUI

struct FoodBowlTile: View {
    @State var pounds: Int
    @State var currentPourState: PouringState = .idle
    @State var pouringSpeed: PouringSpeedEnum = .notpouring
    let MAX_VOLUME = 80

    let tilewidth = UIScreen.main.bounds.size.width / 2 - 25
    
    var body: some View {
       
        VStack{
            ZStack {
                Text("\(Int(CGFloat(pounds)/CGFloat(MAX_VOLUME)*100))% Left")
                Circle()
                    .trim(from: 0, to: CGFloat(pounds) / CGFloat(MAX_VOLUME))
                    .stroke(Color.blue)
                    .rotationEffect(Angle(degrees: 125))
            }
            .padding()
        }
        .onAppear(perform: {
            pounds = 5
            return
        })
        .frame( width: tilewidth, height: 150)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("Lipstick"), lineWidth: 4)
                .shadow(color: .gray, radius:0.5, x: -2.5, y: -5)
        )
        .overlay(
            ScrubbingGestureWrapper { pourMagnitude, gesture in
                if(gesture.state == .ended){
                    currentPourState = .idle
                    pouringSpeed = .notpouring
                    if pounds > MAX_VOLUME {
                        pounds = MAX_VOLUME
                        print("oh no you spilled water everywhere")
                    }
                    return
                }
                
                if currentPourState == .idle {
                    currentPourState = .transition
                    return
                } else if pounds > MAX_VOLUME {
                    print("oh no you spilled food everywhere")
                    pounds = MAX_VOLUME
                    return
                }
                pounds += Int(pourMagnitude / 50)
                
                
            }.frame( width: UIScreen.main.bounds.size.width / 2 - 25, height: 150)
        )
    }
}


struct ScrubbingGestureWrapper: UIViewRepresentable {
    var tapCallback : (Double, UIPanGestureRecognizer) -> Void
    var sharedview = UIView()
    
    typealias UIViewType = UIView
    func makeCoordinator() -> ScrubbingGestureWrapper.Coordinator {
        Coordinator(referencing: sharedview, tapCallback: self.tapCallback)
    }
    func makeUIView(context: UIViewRepresentableContext<ScrubbingGestureWrapper>) -> UIView
    {
       
       let doubleTapPanGestureRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDrag(sender:)))
        /// Set number of touches.
        doubleTapPanGestureRecognizer.minimumNumberOfTouches = 1
        doubleTapPanGestureRecognizer.maximumNumberOfTouches = 1
        sharedview.addGestureRecognizer(doubleTapPanGestureRecognizer)
        return sharedview
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<ScrubbingGestureWrapper>){}
    
    class Coordinator {
        var tapCallback : (Double, UIPanGestureRecognizer) -> Void
        var prevEdge: Double = 0
        unowned var view: UIView
        
        init(referencing: UIView, tapCallback: @escaping (Double, UIPanGestureRecognizer) -> Void) {
            self.tapCallback = tapCallback
            self.view = referencing
        }
        
        @objc func handleDrag(sender: UIPanGestureRecognizer) {
            let translation = sender.translation(in: self.view)
            if translation.y > translation.x + 20 {
                return
            }
            if prevEdge == 0 {
                prevEdge = translation.x
            }
            if(sender.state == .ended || sender.state == .began){
                self.tapCallback(0,sender)
                return
            }
            if(prevEdge > 0){
                if translation.x > prevEdge {
                    prevEdge = translation.x
                }
                let nextEdge = prevEdge * -1 + 9
                if translation.x >= nextEdge {
                    self.tapCallback(abs(prevEdge),sender)
                    
                }
            } else {
                if translation.x < prevEdge {
                    prevEdge = translation.x
                }
                let nextEdge = prevEdge * -1 - 9
                if translation.x <= nextEdge {
                    self.tapCallback(abs(prevEdge),sender)
                    prevEdge = translation.x
                }
            }
        }
    }
    
}

struct FoodBowl_Previews: PreviewProvider {
    static var previews: some View {
        FoodBowlTile(pounds: 50)
    }
}
