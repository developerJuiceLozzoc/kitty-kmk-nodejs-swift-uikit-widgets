//
//  ResizingAdoptionRequirementsView.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 8/1/23.
//

import SwiftUI

fileprivate func idMaker(_ index: Int) -> String {
    "NEIGHBOORD CAT TOY \(index)"
}


struct CustomButtonStyle: ButtonStyle {
    var backgroundColor: Color = Color("ultra-violet-1")
    var textColor: Color = .black
    var textSize: CGFloat = 24
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: textSize))
            .foregroundColor(textColor)
            .padding()
            .background(backgroundColor.opacity(0.3))
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}


struct ResizingAdoptionRequirementsView: View {
    let toysExisting: [ToyItemUsed]
    let toysNeeded: [ToyType]
    
    @State private var currentIndex = -1
    @State private var isDraggingEnabled = true
    @State private var offset: CGSize = .zero
    
    func reset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isDraggingEnabled = true
            offset = .zero
        }
    }

    func triangle(a: Double, b: Double) -> Double {
        return sqrt(a * a + b * b)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = value.translation
                
            }
            .onEnded { _ in
                let scrollOffset = triangle(a: Double(offset.width), b: Double(offset.height))
                text = "\(scrollOffset)"

                    if scrollOffset > 15, isDraggingEnabled {
                        currentIndex = min(currentIndex + 1, toysNeeded.count - 1)
                        isDraggingEnabled = false
                        reset()
                    } else if scrollOffset < -15 {
                        currentIndex = max(currentIndex - 1, 0)
                        isDraggingEnabled = false
                        reset()
                    }
                reset()
            }

    }
    
    func toyUsed(for toy: ToyType) -> ToyItemUsed {
        toysExisting.first { lhs in
            lhs.type.rawValue == toy.rawValue
        } ?? .init(dateAdded: 0.0, type: toy, hits: 0)
    }
    
    var scrollable: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: 0) {
                    ForEach((0..<toysNeeded.count), id: \.self) { index in
                      HStack(spacing: 0) {
                            Spacer(minLength: 200)
                          RequiredToyView(toy: toyUsed(for: toysNeeded[index]), id: idMaker(index))
                            Spacer(minLength: 200)
                        }
                       
                    }
                }
                .onChange(of: currentIndex) { newValue in
                    withAnimation {
                        proxy.scrollTo(idMaker(newValue), anchor: .center)
                    }
                }
            }
        }
        .onAppear {
            currentIndex = 0
        }
    }

    var demand: some View {
        HStack {
            Button("Previous", action: {
                if currentIndex == 0 {
                    currentIndex = toysNeeded.count - 1
                } else {
                    currentIndex = max(currentIndex - 1, 0)
                }
            })
            .buttonStyle(CustomButtonStyle())
            Button("Next", action: {
                if currentIndex == toysNeeded.count - 1 {
                    currentIndex = 0
                } else {
                    currentIndex = min(currentIndex + 1, toysNeeded.count - 1)
                }
            })
            .buttonStyle(CustomButtonStyle())
        }
    }
    
    @State var text = "f"
    
    var columnscolums: [GridItem] = Array.init(repeating: .init(.fixed((UIScreen.main.bounds.width-10)/3)), count: 3)
    
    @State var selectedTabItem: Int = 0
    var body: some View {
        VStack(spacing: 0) {
            scrollable
           demand
        }
    }
    
}

struct ResizingAdoptionRequirementsView_Previews: PreviewProvider {
    static var previews: some View {
        ResizingAdoptionRequirementsView(toysExisting: [.init(dateAdded: Date.now.timeIntervalSince1970, type: .catMouse, hits: 3)], toysNeeded: [.catMouse, .foodPuzzle,.unknown,.yarnball])
    }
}