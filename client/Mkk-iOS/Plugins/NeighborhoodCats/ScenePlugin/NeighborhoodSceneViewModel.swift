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
        var isSceneLoading: Bool = true
        var isZipcodeLoading: Result<NetworkState, KMKNetworkError> = .success(.idle)
        var orientation = UIDeviceOrientation.landscapeLeft
    }
    
    struct NonObservable {
        var sceneDelegate: SimpleSceneDelegate?
        var neighborhoodModel = NeighborhoodModel()
        var cats: KMKNeighborhood?
        var sceneCats: [SceneCat] = []
    }
    
    enum Action {
        
    }
}


extension NeighborhoodScene.ViewModel {
    private func zipCodeCompletion(_ completion: Subscribers.Completion<KMKNetworkError>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch completion {
            case .finished:
                return
            case .failure(let error):
                self.observables.isZipcodeLoading = .failure(error)
            }
        }
    }
    private func zipCodeCompletion(_ receiveValue: KMKNeighborhood) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.nonObservables.cats = receiveValue
            self.observables.isZipcodeLoading = .success(.success)
        }
    }
    
    func neighborHoodOnAppear() {
        switch self.isZipcodeLoading {
        case .failure(_):
            flushCancellables()
            fallthrough
        case .success(.idle):
            if let decodedZipCode = KMKNeighborhoodCatCoder().decode() {
                self.nonObservables.cats = decodedZipCode
                self.observables.isZipcodeLoading = .success(.success)
            } else {
                let publisher = self.nonObservables.neighborhoodModel.queryZipCode()
                publisher
                    .sink(receiveCompletion: self.zipCodeCompletion, receiveValue: self.zipCodeCompletion)
                    .store(in: self)
            }
        default:
            return
        }
    }
    
    convenience init() {
        self.init(observables: .init(), nonobservables: .init())
        let sceneD = SimpleSceneDelegate() { [weak self] (scene, delay) in
            guard let self = self else { return }
            self.shouldRenderCats(in: scene, offset: delay)
        }
        
        self.nonObservables.sceneDelegate = sceneD
    }
    
    private func shouldRenderCats(in scene: SCNScene, offset time: TimeInterval) {
        guard let zipCats = self.nonObservables.cats?.cats else { return }
        let animator: CatAnimator = .init(zipcodeCats: zipCats, start: time)
        self.nonObservables.sceneDelegate?.catAnimator = animator
        animator.load(into: scene)
        
        DispatchQueue.main.async { [weak self] in
            self?.observables.isSceneLoading = false
        }
    }
}


class SimpleSceneDelegate: NSObject, SCNSceneRendererDelegate {
    var sceneDidLoad: ((SCNScene, TimeInterval) -> Void)?
    var catAnimator: CatAnimator?
    var time: Float = 0
    
    public init(
        sceneDidLoad:  ((SCNScene, TimeInterval) -> Void)? = nil
    ) {
        self.sceneDidLoad = sceneDidLoad
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        updateAtTime time: TimeInterval
    ) {
        guard let catAnimator = catAnimator else { return }
//        if let scene = renderer.scene,
//           !catAnimator.hasLoaded
//        {
//
//        } else {
        if catAnimator.hasLoaded {
            self.time += 0.01
            SCNTransaction.begin()
            catAnimator.updatePosidons(at: time)
            SCNTransaction.commit()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard catAnimator == nil else { return }
       
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        if let animator = self.catAnimator,
           animator.hasLoaded,
           sceneDidLoad != nil
        {
            sceneDidLoad = nil
            return
        }
        
        SCNTransaction.begin()
        sceneDidLoad?(scene, time)
        SCNTransaction.commit()
        
        
    }
    
    
}
