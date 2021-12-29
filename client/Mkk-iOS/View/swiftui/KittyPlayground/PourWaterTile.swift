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
    @State var liters: Int
    @State var currentPourState: PouringState = .idle
    @State var pouringSpeed: PouringSpeedEnum = .notpouring
    let steadyThreshold: Double = 20
    let dumpingThreshold: Double = 50
    let tilewidth = UIScreen.main.bounds.size.width / 2 - 25
    
    func fillWater() {
        DispatchQueue.main.async {
            switch self.pouringSpeed {
            case .steady:
                liters += 5
                break
            case .notpouring:
                return
            case .dumping:
                liters += 15
            }
        }
        if liters >= 100 {
            liters = 100
            return
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                guard pouringSpeed != .notpouring else { return }
                fillWater()
            }
        }
        print(liters)
        
    }
    
    var body: some View {
       
        VStack{
            Text("WaterBowl")
            Text("\(currentPourState.rawValue)")
            Text("\(pouringSpeed.rawValue)")
            Text("\(liters)")
            Spacer()
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.blue)
                .frame(width: tilewidth, height: 300 / 2 * CGFloat(liters)/100)
                .animation(.default,value: liters)
        }
        .onAppear(perform: {
            liters = 1
        })
        .frame( width: tilewidth, height: 300)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("Lipstick"), lineWidth: 4)
                .shadow(color: .gray, radius:0.5, x: -2.5, y: -5)
        )
        .overlay(
            TwoFingerDragDownWrapper { taptranslation, dragvelocity, gesture in
                if(gesture.state == .ended){
                    currentPourState = .idle
                    pouringSpeed = .notpouring
                    if liters > 100 {
                        liters = 100
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
                
                
            }.frame( width: UIScreen.main.bounds.size.width / 2 - 25, height: 300)
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
    static var previews: some View {
        HStack(spacing: 21){
            PourWaterTile(liters: 50)
            PourWaterTile(liters: 50)
        }
    }
}
