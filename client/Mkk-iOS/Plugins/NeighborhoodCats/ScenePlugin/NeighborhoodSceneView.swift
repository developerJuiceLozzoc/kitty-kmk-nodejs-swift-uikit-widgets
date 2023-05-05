//
//  NeighborhoodSceneView.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/10/23.
//

import SwiftUI
import SceneKit
import Combine



struct NeighborhoodSceneView: View {
    
    var scene = SCNScene(named: "Neighborhood.scn")
    var cameraNode: SCNNode? {
        scene?.rootNode.childNode(withName: "camera-omni", recursively: false)
    }
    
    @ObservedObject var viewModel = NeighborhoodScene.ViewModel()
    
    
    var activityIndicator: some View {
        VStack {
            if viewModel.observables.isSceneLoading {
                KMKLoadingIndicator(bodyText: "Neighboorhood scene resources Loading")
            }
        }
    }
    
    var portraitBody: some View {
        /* a mobile app styled table view */
        NeighborHoodCatTableView(cats: viewModel.nonObservables.cats?.cats ?? [])
    }
    
    func hitTestSelected(node: SCNNode?) {
        
    }
    
    
    private var sceneView: some View {
        ZStack {
            SceneKitView(
                scene: scene,
                onNodeSelected: self.hitTestSelected,
                delegate: viewModel.nonObservables.sceneDelegate
            )
            .frame(
                width: UIScreen.main.bounds.width * 0.66,
                height: UIScreen.main.bounds.height
            )
            .padding(.top, 16)
            .onAppear(perform: viewModel.neighborHoodOnAppear)
            .overlay {
                if !viewModel.observables.isSceneLoading {
                    Rectangle()
                        .stroke(lineWidth: 4)
                        .fill(Color("ultra-violet-1"))
                }
                
            }
            
            activityIndicator
        }
    }
 
    var landscapeBody: some View {
        /* cringe scenekit meow thing */
        HStack {
            if viewModel.nonObservables.sceneDelegate != nil &&
                viewModel.observables.orientation != .unknown
            {
                sceneView
            }
            portraitBody
        }
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
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.observables.orientation {
            case .landscapeLeft, .landscapeRight :
                landscapeBody
                    .edgesIgnoringSafeArea(.all)
            case .portrait:
                portraitBody
            default:
                Text("We do not support this device orientation, Sorry.")
            }
        }
        .edgesIgnoringSafeArea(edgesIgnored)
        .onReceive(
            NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        ) { _ in
            viewModel.observables.orientation = UIDevice.current.orientation
        }
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
        NeighborhoodSceneView()
    }
}
