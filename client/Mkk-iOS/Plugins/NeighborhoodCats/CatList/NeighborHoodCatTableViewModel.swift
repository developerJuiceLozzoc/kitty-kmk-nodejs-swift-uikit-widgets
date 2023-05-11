//
//  NeighborhoodCatTabls.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 5/2/23.
//

import SceneKit

enum NeighborhoodCatTables {
    typealias ViewModel = StateManagementViewModel<Observable, NonObservable, Action>
    
    struct Observable {
        var isSceneLoading: Bool = true
        var minTimeCanRenderCat: TimeInterval = .infinity
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
            print("cdm may early escape")
            guard let self = self,
                let theCat = scene.rootNode.childNode(withName: "grp1", recursively: true)
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
    
    func didTap(cat: SceneCat) {
        if let node = cat.getMyCat(from: self.nonObservables.scene),
           let finalMaterial = cat.highlightMaterial,
           let initialMaterial = cat.material {
//            SCNTransaction.begin()
//            node.geometry?.materials = [initialMaterial, finalMaterial]
//            SCNTransaction.commit()
            
            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 1.25
//            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)

            // Add the material to the node's geometry
            node.geometry?.materials = [initialMaterial]
            SCNTransaction.commit()
        }
    }
        
    
}

