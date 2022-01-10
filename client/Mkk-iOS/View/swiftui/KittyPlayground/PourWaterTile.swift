//
//  PourWaterTile.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 12/27/21.
//

import SwiftUI

enum PouringState: Int {
    case idle = 0
    case transition
    case pouring
    case overflowing
}
enum PouringSpeedEnum: String {
    case notpouring = "Not Pouring"
    case steady = "Steady"
    case dumping = "Dumping that water"
}

struct PourWaterTile: View {
    @Binding var store: KittyPlaygroundState
    @State var currentPourState: PouringState = .idle
    @State var pouringSpeed: PouringSpeedEnum = .notpouring
    let steadyThreshold: Double = 20
    let dumpingThreshold: Double = 50
    let tilewidth = UIScreen.main.bounds.size.width / 2 - 25
    let maxLiters = 100
    static let tileHeight: CGFloat = 300

    func fillWater() {
        DispatchQueue.main.async {
            switch self.pouringSpeed {
            case .steady:
                self.store.waterbowl += 5
                break
            case .notpouring:
                return
            case .dumping:
                self.store.waterbowl += 15
            }
        }
        if self.store.waterbowl >= maxLiters {
            self.store.waterbowl = maxLiters
            return
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                guard pouringSpeed != .notpouring else { return }
                fillWater()
            }
        }
        
    }
    
    var body: some View {
       
        VStack{
            Text("WaterBowl")
            if self.store.waterbowl > 100 {
                Text("Ooops you spilled water everywhere")
                    .font(.caption)
                    .lineLimit(2)
            }
   
            Spacer()
            if self.store.waterbowl > 0 {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.blue)
                    .frame(width: tilewidth, height: PourWaterTile.tileHeight / 1.33 * CGFloat(self.store.waterbowl)/CGFloat(maxLiters))
                    .animation(.default,value: self.store.waterbowl)
            }
            
        }
        .frame( width: tilewidth, height: PourWaterTile.tileHeight)
        .background(
            KMKSwiftUIStyles.i.renderDashboardTileBG()
        )
        .overlay(
            KMKSwiftUIStyles.i.renderDashboardTileBorder()
        )
        .overlay(
            TwoFingerDragDownWrapper { taptranslation, dragvelocity, gesture in
                if(gesture.state == .ended){
                    currentPourState = .idle
                    pouringSpeed = .notpouring
                    if self.store.waterbowl  > maxLiters {
                        self.store.waterbowl = maxLiters
                        print("oh no you spilled water everywhere")
                    }
                    return
                }
                
                if currentPourState == .idle {
                    currentPourState = .transition
                    return
                } else if dragvelocity > 0 && taptranslation > 0 {
                    if taptranslation > 8 && currentPourState != .pouring {
                        currentPourState = .pouring
                        fillWater()
                    }
                    
                    if taptranslation > dumpingThreshold && pouringSpeed == .steady {
                        pouringSpeed = .dumping
                    }
                    else if taptranslation > steadyThreshold && pouringSpeed == .notpouring {
                        pouringSpeed = .steady
                    }
                } else if dragvelocity < 0 {
                    if pouringSpeed == .dumping && taptranslation < dumpingThreshold - 3 {
                        pouringSpeed = .steady
                    } else if pouringSpeed == .steady && taptranslation < steadyThreshold - 2  {
                        pouringSpeed = .notpouring
                    }
                }
                
                
            }.frame( width: UIScreen.main.bounds.size.width / 2 - 25, height: PourWaterTile.tileHeight)
        )
    }
}


struct TwoFingerDragDownWrapper: UIViewRepresentable {
    var tapCallback : (Double,Double, UIPanGestureRecognizer) -> Void
    var sharedview = UIView()
    typealias UIViewType = UIView
    func makeCoordinator() -> TwoFingerDragDownWrapper.Coordinator {
        Coordinator(referencing: sharedview, tapCallback: self.tapCallback)
    }
    func makeUIView(context: UIViewRepresentableContext<TwoFingerDragDownWrapper>) -> UIView
    {
       
       let doubleTapPanGestureRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDrag(sender:)))
        /// Set number of touches.
        doubleTapPanGestureRecognizer.minimumNumberOfTouches = 2
        sharedview.addGestureRecognizer(doubleTapPanGestureRecognizer)
        return sharedview
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<TwoFingerDragDownWrapper>){}
    
    class Coordinator {
        var tapCallback : (Double,Double, UIPanGestureRecognizer) -> Void
        unowned var view: UIView
        init(referencing: UIView, tapCallback: @escaping (Double,Double, UIPanGestureRecognizer) -> Void) {
            self.tapCallback = tapCallback
            self.view = referencing
        }
        
        @objc func handleDrag(sender: UIPanGestureRecognizer) {
            let translation = sender.translation(in: self.view)
            let velocity = sender.velocity(in: self.view)
            self.tapCallback(translation.y,velocity.y, sender)
        }
    }
    
}

struct PourWaterTile_Previews: PreviewProvider {
    @State static var value = KittyPlaygroundState(foodbowl: 50, waterbowl: 50, toys: [ToyItemUsed(dateAdded: Date().timeIntervalSince1970, type: .chewytoy, hits: 20)])

    static var previews: some View {
        HStack(spacing: 21){
            PourWaterTile(store: $value)
            PourWaterTile(store: $value)
        }
    }
}
