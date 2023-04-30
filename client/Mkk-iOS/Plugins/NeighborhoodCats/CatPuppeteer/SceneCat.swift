//
//  CatPuppeteer.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/19/23.
//

import SceneKit
import MetalKit
import SceneKit.ModelIO


typealias CatHike = (end1: SCNVector3, end2: SCNVector3)
/* this makes action on a scene and will render a cat walking
 each render. They will stick to bumping around */

struct SceneCat {
    /* how many unique cats can i make?
     preferably 10,000
     */
    
    var hasLoaded = false
    var phaseShift: Double
    var currentHike: HikesCatGoes
    let catDetails: ZipcodeCat?
    var p: SCNNode?
    
    init(role desinatedHike: HikesCatGoes, delay: TimeInterval) {
        self.currentHike = desinatedHike
        self.phaseShift = delay
    }
    
    init(zipcodeCat: ZipcodeCat, role hike: HikesCatGoes) {
        
    }
    
    private func urlForFile(named: String) -> String? {

        if let url = Bundle.main.path(forResource: named, ofType: "tif", inDirectory: "assets.scnassets") {
            return url
        } else if let url = Bundle.main.path(forResource: named, ofType: "png", inDirectory: "assets.scnassets") {
            return url
        } else if let url = Bundle.main.path(forResource: named, ofType: "jpg", inDirectory: "assets.scnassets") {
            return url
        }
        else {
            return nil
        }


    }
    
    private func material(named prefix: String) -> SCNMaterial? {
        let material = SCNMaterial()
        guard let device = MTLCreateSystemDefaultDevice() else { return nil }
        // Load the textures
        let textureLoader = MTKTextureLoader(device: device)

        
        if let path = urlForFile(named: "\(prefix)roughness"),
           let roughnessData = try? Data(contentsOf: .init(fileURLWithPath: path)),
           let roughnessTexture = try? textureLoader.newTexture(data: roughnessData) {
            material.roughness.contents = roughnessTexture
        }
        
        if let path = urlForFile(named: "\(prefix)metallic"),
           let metalData = try? Data(contentsOf: .init(fileURLWithPath: path)),
            let metallicTexture = try? textureLoader.newTexture(data: metalData) {
            material.metalness.contents = metallicTexture
        }
        
        if let path = urlForFile(named: "\(prefix)diffuse"),
           let diffuseData = try? Data(contentsOf: .init(fileURLWithPath: path)),
           let diffuseTexture = try? textureLoader.newTexture(data: diffuseData) {
            material.diffuse.contents = diffuseTexture
        }
        
        if let path = urlForFile(named: "\(prefix)ao"),
           let ambientOcclusionData = try? Data(contentsOf: .init(fileURLWithPath: path)),
           let ambientOcclusionTexture = try? textureLoader.newTexture(data: ambientOcclusionData) {
            material.ambientOcclusion.contents = ambientOcclusionTexture
        }

        return material
    }
    
    static var randomActiveColor: String {
        let arr = [
            "purple",
            "blue",
            "border-gradient-topleft",
            "dashboard-tile-bg-gradient-1",
            "dashboard-tile-bg-gradient-end",
            "emoji-foreground",
            "form-label-color",
            "list-kitty-name-gradient-end-color",
            "ultra-violet-1"
        ]
        return arr.randomElement() ?? "ultra-violet-1"
    }
    
    static var randomTexturePrefix: String {
        let arr = [
            "TexturesCom_Wood_GrateShipdeck_1x1_512_",
            "TexturesCom_Wood_BarkYucca1_0.125x0.125_512_",
            "TexturesCom_Snow_TireMarks4_3x3_1K_",
            "TexturesCom_Snow_Footsteps_2x2_1K_",
            "TexturesCom_Pipe_AluminiumExpanded_0.30x0.30_1K_",
            "TexturesCom_Metal_RustedPlates1_1x1_512_",
            "Concrete_Wall_008_",
            "TexturesCom_Wall_BrickIndustrial5_2x2_1K_",
            "TexturesCom_Brick_CinderblocksPainted2_1K_",
            "Jungle_Floor_001_",
            "Ground_Forest_002_",
            "Concrete_Wall_012_",
            "TexturesCom_SolarCells_1K_",
            "TexturesCom_Wood_SidingOutdoor6_2x2_1K_"
        ]
        return arr.randomElement() ?? "Concrete_Wall_008_"
    }
    
    public func loadGeometry() -> SCNNode? {
        guard let scene = SCNScene(named: "cat.scn"),
              let nodeToMove = scene.rootNode.childNode(withName: "grp1", recursively: true),
              let material = material(named: SceneCat.randomTexturePrefix) else {
            print("Node is not in a scene")
            return nil
        }

        // Remove the node from its current scene
        nodeToMove.removeFromParentNode()

        nodeToMove.geometry?.materials = [material]
        return nodeToMove
    }
    
    
}


