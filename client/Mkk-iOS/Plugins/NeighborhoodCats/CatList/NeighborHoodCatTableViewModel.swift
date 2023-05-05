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
    
    func didTap(indexPath: Int) {
        let cat = self.nonObservables.cats[indexPath]
        if let node = cat.getMyCat(from: self.nonObservables.scene),
           let finalMaterial = cat.highlightMaterial,
           let initialMaterial = cat.material {
            SCNTransaction.begin()
            node.geometry?.materials = [initialMaterial, finalMaterial]
            SCNTransaction.commit()
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1.25
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)

            // Add the material to the node's geometry
            node.geometry?.materials = [initialMaterial]
            SCNTransaction.commit()
        }
    }
        
    convenience init(with cats: [ZipcodeCat]) {
        self.init(observables: .init(), nonobservables: .init())
        let sceneD = SimpleSceneDelegate() { [weak self] (scene, delay) in
            guard let self = self else { return }
            self.nonObservables.cats = cats.map { SceneCat(zipcodeCat: $0, role: HikesCatGoes.allCases.randomElement() ?? .apartments, delay: delay)}
            self.observables.minTimeCanRenderCat = delay
        }
        
        self.nonObservables.sceneDelegate = sceneD
    }
}

