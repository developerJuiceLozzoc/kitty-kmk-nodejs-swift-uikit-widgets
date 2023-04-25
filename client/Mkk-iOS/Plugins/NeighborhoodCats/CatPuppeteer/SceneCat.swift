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
    
    var hasLoaded = false
    var phaseShift: Double
    
    public init(role desinatedHike: HikesCatGoes, delay: TimeInterval) {
        self.currentHike = desinatedHike
        self.phaseShift = delay
    }
    /*
     let directoryPath = Bundle.main.resourcePath?.appending("/SceneAssets") ?? ""
     let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants, .skipsPackageDotFiles, .skipsHiddenFileExtensions]
     let enumerator = FileManager.default.enumerator(atPath: directoryPath)
     while let filename = enumerator?.nextObject() as? String {
         if filename.hasSuffix(".jpg") {
             let filePath = directoryPath.appending("/\(filename)")
             print("Found file: \(filePath)")
             // Do something with the file...
         }
     }

     */
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
    
    var randomTexturePrefix: String {
        let arr = [
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
              let material = material(named: randomTexturePrefix) else {
            print("Node is not in a scene")
            return nil
        }

        // Remove the node from its current scene
        nodeToMove.removeFromParentNode()

        nodeToMove.geometry?.materials = [material]
        return nodeToMove
    }
    
    var currentHike: HikesCatGoes
    var p: SCNNode?
}


