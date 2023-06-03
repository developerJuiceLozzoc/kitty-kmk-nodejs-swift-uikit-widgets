//
//  SimpleSceneDelegate.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 6/1/23.
//

import Foundation
import Combine
import SceneKit


class SimpleSceneDelegate: NSObject, SCNSceneRendererDelegate {
    var sceneDidLoad: ((SCNScene, TimeInterval) -> Void)?
    var catAnimator: CatAnimator?
    var phaseTime: Float = 0
    
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

        
        if catAnimator.hasLoaded {
            self.phaseTime += 0.01
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
            phaseTime = Float(time)
            sceneDidLoad = nil
            return
        } 
        if let completion = sceneDidLoad {
            DispatchQueue.main.async {
                completion(scene, time)
            }
        }
        
    }
}

/*
class MaterialAnimation: SCNAnimation {
    override func u
    override func updateAnimation(_ animation: CAAnimation, animatedNode: SCNNode) {
        guard let player = animation as? SCNAnimationPlayer,
              let geometry = animatedNode.geometry,
              let geometryMaterials = geometry.materials,
              geometryMaterials.count == materials.count else {
            return
        }
        
        let time = player.animation.currentTime / player.animation.duration
        
        // Interpolate the alpha value based on the time
        let interpolatedAlpha = blendValues(from: 1.0, to: 0.0, with: time)
        
        // Update the material's diffuse property with the interpolated alpha
        let material = geometryMaterials[0]
        let color = material.diffuse.contents as? UIColor
        let updatedColor = color?.withAlphaComponent(interpolatedAlpha)
        material.diffuse.contents = updatedColor
    }
    
    // Function to interpolate values
    private func blendValues(from startValue: CGFloat, to endValue: CGFloat, with progress: CGFloat) -> CGFloat {
        return startValue + (endValue - startValue) * progress
    }
}
*/
