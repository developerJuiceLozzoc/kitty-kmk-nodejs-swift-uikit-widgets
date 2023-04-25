//
//  CatAnimator.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/24/23.
//

import SceneKit


class CatAnimator {
    
    var cats: [SceneCat] = []
    
    public var hasLoaded: Bool {
        let count = self.cats.count
        for i in (0..<count) {
            if self.cats[i].hasLoaded {
                continue
            } else {
                return false
            }
        }
        return true
    }
    init(catCount: Int) {
        for _ in (0..<catCount) {
            let role = HikesCatGoes.allCases.randomElement() ?? .apartments
            let cat = SceneCat(role: role )
            self.cats.append(cat)
            
        }
        
    }
    func load(into scene: SCNScene) {
        for index in (0..<self.cats.count) {
            let cat = self.cats[index]
            if let initialPosition = cat.currentHike.postion(time: 0),
               let node = cat.loadGeometry() {
                self.cats[index].hasLoaded = true
                self.cats[index].p = node
                scene.rootNode.addChildNode(node)
                node.position = initialPosition
                node.scale = .init(SIMD3<Float>.init(repeating: 0.06))
            }
            
        }
        
        
    }
    
    func startAnimating(at time: Float) {
        self.cats.forEach { cat in
            if let node = cat.p,
                let nextPosition = cat.currentHike.postion(time: time) {
                node.position = nextPosition
            }
        }
    }
}
