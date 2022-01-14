//
//  FoodBowl.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//

import SwiftUI

struct FoodBowlTile: View {
    @Binding var store: KittyPlaygroundState
    @State var currentPourState: PouringState = .idle
    @State var pouringSpeed: PouringSpeedEnum = .notpouring
    let MAX_VOLUME = 80
    static let tileHeight: CGFloat = 150

    let tilewidth = UIScreen.main.bounds.size.width / 2 - 25
    
    
    func calculateFoodLevel() -> Int {
        if CGFloat(self.store.foodbowl) > 80.0 * 0.75 {
          return 3
        } else if CGFloat(self.store.foodbowl) > 80.0 * 0.50 {
            return 2
        } else if CGFloat(self.store.foodbowl) > 80.0 * 0.25 {
            return 1
        } else {
            return 0
        }
    }
    
    var body: some View {
       
        VStack{
            ZStack {
                VStack{
                    Text("Food Bowl")
                    FoodLevelIndicator(lvl: self.calculateFoodLevel())
                }
                Circle()
                    .trim(from: 0, to: CGFloat(self.store.foodbowl) / CGFloat(MAX_VOLUME))
                    .stroke(Color.blue)
                    .rotationEffect(Angle(degrees: 125))
            }
            .padding()
        }
        .frame( width: tilewidth, height: FoodBowlTile.tileHeight)
        .background(
            KMKSwiftUIStyles.i.renderDashboardTileBG()
        )
        .overlay(
            KMKSwiftUIStyles.i.renderDashboardTileBorder()
        )
        .overlay(
            ScrubbingGestureWrapper { pourMagnitude, gesture in
                if(gesture.state == .ended){
                    currentPourState = .idle
                    pouringSpeed = .notpouring
                    if self.store.foodbowl > MAX_VOLUME {
                        self.store.foodbowl = MAX_VOLUME
                        print("oh no you spilled water everywhere")
                    }
                    return
                }
                
                if currentPourState == .idle {
                    currentPourState = .transition
                    return
                } else if self.store.foodbowl > MAX_VOLUME {
                    print("oh no you spilled food everywhere")
                    self.store.foodbowl = MAX_VOLUME
                    return
                }
                self.store.foodbowl += Int(pourMagnitude / 50)
                
                
            }.frame( width: UIScreen.main.bounds.size.width / 2 - 25, height: FoodBowlTile.tileHeight)
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
    @State static var value = KittyPlaygroundState(foodbowl: 0, waterbowl: 50, toys: [ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .chewytoy, hits: 50)])

    static var previews: some View {
        FoodBowlTile(store: $value)
    }
}
