//
//  NeighborhoodCatTabls.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 5/2/23.
//

import SceneKit
import SwiftUI

enum NeighborhoodCatTables {
    typealias ViewModel = StateManagementViewModel<Observable, NonObservable, Action>
    
    struct Observable {
        var isSceneLoading: Bool = true
        var minTimeCanRenderCat: TimeInterval = .infinity
        var detailsViewModel: ZipcodeDetails.ViewModel?
        var shimmeringTowardsCat: ZipcodeCat?
    }
    
    struct NonObservable {
        var sceneDelegate: SimpleSceneDelegate?
        var scene: SCNScene? = SCNScene(named: "cat.scn")
        var cats: [SceneCat] = []
    }
    
    enum Action {
        
    }
}

extension NeighborhoodCatTables.ViewModel {
    convenience init(with cats: [ZipcodeCat]) {
        self.init(observables: .init(), nonobservables: .init())
        self.nonObservables.sceneDelegate = SimpleSceneDelegate() { [weak self] (scene, delay) in
            guard let self = self
            else {
                return
            }
            self.nonObservables.cats = cats.map { SceneCat(zipcodeCat: $0, role: HikesCatGoes.allCases.randomElement() ?? .apartments, delay: delay)}
            self.observables.minTimeCanRenderCat = delay
            self.observables.isSceneLoading = false
            let catAnimator: CatAnimator = .init(zipcodeCats: cats, start: delay)
            catAnimator.load(into: scene)
            self.nonObservables.sceneDelegate?.catAnimator = catAnimator
        }
    }
}


extension NeighborhoodCatTables.ViewModel {
    
    var bindingDetailsIsActive: Binding<Bool> {
        .init {
            self.observables.detailsViewModel != nil
        } set: { newValue in
            if !newValue {
                self.observables.detailsViewModel = nil
            }
        }
        
    }
    
    func didTap(with cat: SceneCat) {
        var scene = cat
        scene.p = cat.getMyCat(from: self.nonObservables.scene)
        let task = DispatchWorkItem() {
            
        }
        
        CatColorAnimator.shared.animateCat(cat: scene, duration: 1.0, completion: task)

    }
    
    func didLongPress(cat: SceneCat) {
        self.observables.shimmeringTowardsCat = cat.catDetails
        let duration: CFTimeInterval = 2.25
        var catScene = cat
        catScene.p = cat.getMyCat(from: self.nonObservables.scene)
        let workItem2 = DispatchWorkItem { [weak self] in
            // animation has completed, now we shimmer.
            guard let self = self else { return }
            Dispatch.DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self,
                let cat = catScene.catDetails else { return }
                
                self.observables.detailsViewModel = .init(with: cat)
            }
        }
        CatColorAnimator.shared.animateCat(cat: catScene, duration: duration, completion: workItem2)
        
    }
        
    
}

