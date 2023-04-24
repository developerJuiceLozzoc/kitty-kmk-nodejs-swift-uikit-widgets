//
//  NeighborHoodSceneViewRepresentable.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/19/23.
//

import SwiftUI
import SceneKit

//class SpySceneView: SCNView {
//    override func app
//}

struct SceneKitView: UIViewRepresentable {
    let scene: SCNScene?
    let onNodeSelected: ((SCNNode) -> Void)?
    weak var delegate: SCNSceneRendererDelegate?
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView(frame: .zero)
        scnView.scene = scene
        scnView.delegate = delegate
        scnView.backgroundColor = .clear
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator,
                                                 action: #selector(Coordinator.handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        return scnView
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        // Nothing to do here
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: SceneKitView
        
        init(_ parent: SceneKitView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let scnView = gestureRecognizer.view as! SCNView
            let touchLocation = gestureRecognizer.location(in: scnView)
            
            let hitTestResults = scnView.hitTest(touchLocation, options: [:])
            if let node = hitTestResults.first?.node {
                parent.onNodeSelected?(node)
            }
        }
    }
}
