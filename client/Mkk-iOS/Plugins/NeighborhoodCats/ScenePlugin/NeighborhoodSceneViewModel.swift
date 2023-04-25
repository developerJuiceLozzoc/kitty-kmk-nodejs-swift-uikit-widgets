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
        var sceneDelegate: SimpleSceneDelegate?
        var isSceneLoading: Bool = true
        var orientation = UIDeviceOrientation.landscapeLeft
    }
    
    struct NonObservable {
//        var catAnimator =
    }
    
    enum Action {
        
    }
}


extension NeighborhoodScene.ViewModel {
    convenience init() {
        self.init(observables: .init(), nonobservables: .init())
        let sceneD = SimpleSceneDelegate() { [weak self] scene in
            guard let self = self,
                  self.isSceneLoading else {
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
    var catAnimator: CatAnimator?
    var time: Float = 0
    
    public init(
        sceneDidLoad: ((SCNScene) -> Void)? = nil
    ) {
        self.sceneDidLoad = sceneDidLoad
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        updateAtTime time: TimeInterval
    ) {
        guard let catAnimator = catAnimator else { return }
        if let scene = renderer.scene,
           !catAnimator.hasLoaded
        {
            SCNTransaction.begin()
            catAnimator.load(into: scene)
            SCNTransaction.commit()
        } else {
            self.time += 0.01
            SCNTransaction.begin()
            catAnimator.startAnimating(at: time)
            SCNTransaction.commit()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard catAnimator == nil else { return }
        catAnimator = .init(catCount: 6, start: time)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        sceneDidLoad?(scene)

    }
    
    
}
