//
//  ZipcodeCatDetailsViewModel.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 5/19/23.
//


import Foundation
import SceneKit
import SwiftUI
import Combine


enum ZipcodeDetails {}

extension ZipcodeDetails {
    typealias ViewModel = StateManagementViewModel<Observable, NonObservable, Action>
    
    struct Observable {
        var isBreedsLoading: Result<Bool, KMKNetworkError> = .success(false)
        var isSceneLoading: Result<Bool, KMKNetworkError> = .success(true)
        var toysAlreadyExisting: [ToyItemUsed]?
    }
    
    struct NonObservable {
        var breed: KittyBreed?
        var token: ZipcodeCat
        // possible images for cat.
        // material thing comes from the
        var images: [URL]? = nil
        
        var scene = SCNScene(named: "cat.scn")
        var sceneDelegate: SimpleSceneDelegate?
        var isSceneLoading: Result<Bool, KMKNetworkError> = .success(true)
    }
    
    enum Action {
        
    }
}

extension ZipcodeDetails.ViewModel {
    
    convenience init(with cat: ZipcodeCat) {
        self.init(observables: .init(), nonobservables: .init(token: cat))
        self.nonObservables.sceneDelegate = SimpleSceneDelegate() { [weak self] (scene, delay) in
            guard let self = self,
                  let mycat = scene.rootNode.childNode(withName: "grp1", recursively: true)
            else { return }
            self.observables.isSceneLoading = .success(false)
            let catAnimator: CatAnimator = .init(zipcodeCats: [cat], start: delay)
            catAnimator.load(into: scene)
            self.nonObservables.sceneDelegate?.catAnimator = catAnimator
            
            
            var scenecat = SceneCat(zipcodeCat: cat, role: .mansionPath, delay: delay)
            scenecat.p = mycat
            let task = DispatchWorkItem() {
                
            }
            
            CatColorAnimator.shared.animateCat(cat: scenecat, duration: 1.0, completion: task)
            
        }
    }
    
}

/* Business logic */
extension ZipcodeDetails.ViewModel {
    
    func viewDidAppear() {
        let manager = KittyPlistManager()
        if let state  = manager.LoadItemFavorites() {
            self.observables.toysAlreadyExisting = state.toys
        }
    }
    
    func getDetailsCall() {
        // first fetch the breed
        // then fetch images
    }
    
}

