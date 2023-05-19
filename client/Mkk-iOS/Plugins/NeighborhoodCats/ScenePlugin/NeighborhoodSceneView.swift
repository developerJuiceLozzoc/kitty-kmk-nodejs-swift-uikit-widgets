//
//  NeighborhoodSceneView.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/10/23.
//

import SwiftUI
import SceneKit
import Combine

extension View {
    var getStatusBarHeight: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        {
            return windowScene
                .windows
                .first { $0.isKeyWindow }?
                .windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return 0
        }
    }
    
}



struct NeighborhoodSceneView: View {
    private let orientationChanged = NotificationCenter.default
          .publisher(for: UIDevice.orientationDidChangeNotification)
          .makeConnectable()
          .autoconnect()

    
    @ObservedObject var viewModel: NeighborhoodScene.ViewModel
    public init(viewModel: NeighborhoodScene.ViewModel) {
        self.viewModel = viewModel
    }
    
    var activityIndicator: some View {
        VStack {
            if viewModel.observables.isSceneLoading {
                KMKLoadingIndicator(bodyText: "Neighboorhood scene resources Loading")
            }
        }
    }
    
    var portraitBody: some View {
        VStack(spacing: 0){
            if viewModel.isZipcodeLoading == .success(.success) {
                NeighborHoodCatTableView(from: self.viewModel) { details in
                    viewModel.onSelected(cat: details)
                }
            }
        }
        
        /* a mobile app styled table view */
        
    }
    
    func hitTestSelected(node: SCNNode?) {
        
    }
    
    
    private var sceneView: some View {
        ZStack {
            SceneKitView(
                scene: viewModel.nonObservables.neighborhoddScene,
                onNodeSelected: self.hitTestSelected,
                delegate: viewModel.nonObservables.sceneDelegate
            )
            .overlay {
                if viewModel.observables.isSceneLoading {
                    Rectangle()
                        .stroke(lineWidth: 4)
                        .fill(Color("ultra-violet-1"))
                }
                
            }
            .frame(
                width: UIScreen.main.bounds.width * 0.6,// + 25 = 85,
                height: UIScreen.main.bounds.height
            )
            
            activityIndicator
        }
    }
 
    var landscapeBody: some View {
        /* cringe scenekit meow thing */
        HStack(spacing: 0) {
            if viewModel.nonObservables.sceneDelegate != nil
            {
                sceneView
            }
            portraitBody
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea([.leading])
    }
    
    var edgesIgnored: Edge.Set {
        let type = kmk_readOsType()
        switch type {
        case .mac, .simulator:
            return .all

        default:
            return []
        }
    }
    @State private var orientationPublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let isLandscape = size.width > size.height
            if isLandscape,
               #available(iOS 16.0, *) {
                landscapeBody
                    .toolbar(.hidden, for: .tabBar)
                    .environment(\.myCustomValue, true)
            } else if isLandscape {
                    landscapeBody
                        .environment(\.myCustomValue, true)
            } else {
                portraitBody
            }
        }.onAppear(perform: viewModel.neighborHoodOnAppear)
        
    }

}

/// Create custom environment values by defining a key
/// that conforms to the ``EnvironmentKey`` protocol, and then using that
/// key with the subscript operator of the ``EnvironmentValues`` structure
/// to get and set a value for that key:
///
private struct NeighborHoodLayoutIsLandscape: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var myCustomValue: Bool {
        get { self[NeighborHoodLayoutIsLandscape.self] }
        set { self[NeighborHoodLayoutIsLandscape.self] = newValue }
    }
}


/*
 
 there will be several,2-5 cats in the neighborhood that are created and exist.
 every month they will be refreshed, unless 4-5 cats remain, then they will form family.
 
 how do you attrack them? you need to have the correct specific toy set to aquire them/attract. You can always dismiss acat if you did not wish to receive them.
 
 so on this screen you will have a list of cats, and when you successfuly attrack one you can enter a navigation view to adopt or not addopt.
 
 possibly using sprite kit i can animate some static stock photos of cats of them bouncing around in a circle, and then there will be an area somewhere else representing your porch where they found the toys they wanted.
 
 My Porch.
 
 when you click on a cat bouncing around in the circle then it will present a sheet? yes a sheet with details that can be dismissed.
 
 */

struct ListNeighborhoodCatsView_Previews: PreviewProvider {
    static var previews: some View {
        NeighborhoodSceneView(viewModel: .init())
    }
}
