//
//  OrientationManager.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 5/5/23.
//

import SwiftUI
import Combine


func kmk_initialOrientation() ->  OrientationAwareModifier.Orientation {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene as? UIWindowScene else { return .unknown }
    
    switch sceneDelegate.interfaceOrientation {
    case .portrait:
        return .portrait
    case .landscapeLeft,.landscapeRight:
        return .landscape
    default: return .unknown
    }
}

func kmk_getOrientation() ->  OrientationAwareModifier.Orientation {
    let screenBounds = UIScreen.main.bounds
    let isLandscape = screenBounds.width > screenBounds.height
    return isLandscape ? .landscape : .portrait
}


struct SizeCategoryPreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct OrientationAwareModifier: ViewModifier {
    let orientationChanged: (Orientation) -> Void
    enum Orientation {
        case portrait
        case landscape
        case unknown
    }

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .onAppear {
                    calculateOrientation(geometry: geometry)
                }
                .onChange(of: geometry.size) { _ in
                    calculateOrientation(geometry: geometry)
                }
        }
    }

    private func calculateOrientation(geometry: GeometryProxy) {
        let isLandscape = geometry.size.width > geometry.size.height
        
    }
}

struct OrientationAwareModifier2: ViewModifier {
    let orientationChanged: (Orientation) -> Void

    enum Orientation {
        case portrait
        case landscape
        case unknown
    }

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(SizeCategoryPreferenceKey.self) { _ in
                let screenBounds = UIScreen.main.bounds
                let isLandscape = screenBounds.width > screenBounds.height
                orientationChanged( isLandscape ? .landscape : .portrait)
                
            }
    }

    private func updateOrientation(using size: CGSize) {
        let newOrientation: Orientation = size.width > size.height ? .landscape : .portrait

        DispatchQueue.main.async {
            orientationChanged(newOrientation)
        }
    }
}

extension View {
    func onOrientationChange(_ orientationChanged: @escaping (OrientationAwareModifier.Orientation) -> Void) -> some View {
        self.modifier(OrientationAwareModifier(orientationChanged: orientationChanged))
    }
}
