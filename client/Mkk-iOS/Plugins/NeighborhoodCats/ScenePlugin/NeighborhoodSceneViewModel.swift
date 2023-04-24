//
//  NeighborhoodSceneViewModel.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/15/23.
//

import Foundation
import Combine
import SceneKit


enum NeighborhoodScene {}

extension NeighborhoodScene {
    typealias ViewModel = StateManagementViewModel<Observable, NonObservable, Action>
    
    struct Observable {
        var sceneDelegate: SCNSceneRendererDelegate?
        var isSceneLoading: Bool = true
        var orientation = UIDeviceOrientation.landscapeLeft
    }
    
    struct NonObservable {
        
    }
    
    enum Action {
        
    }
}


extension NeighborhoodScene.ViewModel {
    convenience init() {
        self.init(observables: .init(), nonobservables: .init())
        let sceneD = SimpleSceneDelegate()
        sceneD.sceneDidLoad = { [weak self] scene in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.observables.isSceneLoading = false
            }
        }
        
        self.observables.sceneDelegate = sceneD
    } 
}


class SimpleSceneDelegate: NSObject, SCNSceneRendererDelegate {
    var sceneDidLoad: ((SCNScene) -> Void)?
    
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        sceneDidLoad?(scene)
    }
    
    
}
