//
//  CatPuppeteer.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/19/23.
//

import SceneKit
import MetalKit

typealias CatHike = (end1: SCNVector3, end2: SCNVector3)
/* this makes action on a scene and will render a cat walking
 each render. They will stick to bumping around */

struct SceneCat {
    
    public init?(role desinatedHike: HikesCatGoes) {
        self.currentHike = desinatedHike
        if let sceneURL = Bundle.main.url(forResource: "cat", withExtension: "obj") {
            self.sceneURL = sceneURL
        } else {
            return nil
        }
    }
    
    private func material(named prefix: String) -> SCNMaterial? {
        let material = SCNMaterial()
        guard let device = MTLCreateSystemDefaultDevice() else { return nil }
        // Load the textures
        let textureLoader = MTKTextureLoader(device: device)

        
        if let roughnessTexture = try? textureLoader.newTexture(name: "\(prefix)roughness", scaleFactor: 1.0, bundle: Bundle.main, options: nil) {
            material.roughness.contents = roughnessTexture
        }
        if let metallicTexture = try? textureLoader.newTexture(name: "\(prefix)metallic", scaleFactor: 1.0, bundle: Bundle.main, options: nil) {
            material.metalness.contents = metallicTexture
        }
        if let diffuseTexture = try? textureLoader.newTexture(name: "\(prefix)diffuse", scaleFactor: 1.0, bundle: Bundle.main, options: nil) {
            material.diffuse.contents = diffuseTexture
        }
        if let ambientOcclusionTexture = try? textureLoader.newTexture(name: "\(prefix)ao", scaleFactor: 1.0, bundle: Bundle.main, options: nil) {
            material.ambientOcclusion.contents = ambientOcclusionTexture
        }

        return material
    }
    
    var randomTexturePrefix: String {
        [
            "Concrete_Wall_008",
            "TexturesCom_Wall_BrickIndustrial5_2x2_1K_",
            "TexturesCom_Brick_CinderblocksPainted2_1K_",
            "Jungle_Floor_001_",
            "Ground_Forest_002_",
            "Concrete_Wall_012_",
            "TexturesCom_SolarCells_1K_",
            "TexturesCom_Wood_SidingOutdoor6_2x2_1K_"
        ]
        .first ?? "Concrete_Wall_008"
    }
    
    public func loadGeometry() -> SCNNode? {
        let sceneSource = SCNSceneSource(url: sceneURL, options: nil)
        guard let geometry = sceneSource?.entryWithIdentifier("cat_node", withClass: SCNGeometry.self),
              let material = material(named: randomTexturePrefix) else {
            return nil
        }
        geometry.materials.append(material)
        let node = SCNNode(geometry: geometry)
        
        
        return node
        
    }
    
    var sceneURL: URL
    var currentHike: HikesCatGoes
    var node: SCNNode?
}


