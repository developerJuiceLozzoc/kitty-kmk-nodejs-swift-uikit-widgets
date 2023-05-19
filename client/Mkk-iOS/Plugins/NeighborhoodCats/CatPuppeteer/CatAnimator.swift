//
//  CatAnimator.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/24/23.
//

import SceneKit

typealias AnimatedCatTracking = (cat: SceneCat, timeInteracted: TimeInterval)

class CatAnimator {
    
    var cats: [SceneCat] = []
    var catsCurrentlyActive: [AnimatedCatTracking] = []
    
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
    
    init(zipcodeCats: [ZipcodeCat], start time: TimeInterval) {
        var i = 0
        zipcodeCats.forEach { zipped in
            let role = HikesCatGoes.allCases.randomElement() ?? .apartments
            let delay = Double.pi / 2 * Double(i) + time + Double.random(in: 0...1.69)
            let cat = SceneCat(zipcodeCat: zipped, role: role, delay: delay)
            self.cats.append(cat)
            i += 1
        }
    }
    
    func load(into scene: SCNScene) {
        for index in (0..<self.cats.count) {
            let cat = self.cats[index]
            if let initialPosition = cat.currentHike.postion(time: 0),
               let node = cat.loadGeometry() {
                self.cats[index].hasLoaded = true
                self.cats[index].p = node
                SCNTransaction.begin()
                scene.rootNode.addChildNode(node)
                node.position = initialPosition
                node.scale = .init(SIMD3<Float>.init(repeating: 0.069))
                SCNTransaction.commit()
            }
        }
    }
    
    func updatePosidons(at time: TimeInterval) {
        self.cats.forEach { cat in
            var sinusoidalTime = (Float((time - cat.phaseShift)).truncatingRemainder(dividingBy: Float.pi * 2) + -Float.pi)
            if sinusoidalTime < 0 {
                sinusoidalTime *= -1
            }

            
            if let node = cat.p,
               let nextPosition = cat.currentHike.postion(time: sinusoidalTime),
               time > cat.phaseShift {
                node.position = nextPosition
            }
        }
    }
    
    
    /* TODO: tap gestures on the scene */
    func startAnimating(cat: SceneCat, at time: TimeInterval) {
        let numCatsToAnimate = catsCurrentlyActive.count
        for i in (0..<numCatsToAnimate) {
            let animatingTime = catsCurrentlyActive[i].timeInteracted
//            let cat = catsCurrentlyActive[i].cat
//            guard let node = cat.p
//            else { continue }
            
            
            if time > animatingTime {
                catsCurrentlyActive.remove(at: i)
                return
            }
        }
    }
}

class CatColorAnimator {
    static let shared = CatColorAnimator()
    private init() { }
    
    static func averageColor(image: UIImage) -> UIColor? {
        guard let cgImage = image.cgImage else { return nil}
        let ciImage = CIImage(cgImage: cgImage)
        let extent = ciImage.extent
        
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: ciImage, kCIInputExtentKey: extent])!
        let outputImage = filter.outputImage!
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        let red = CGFloat(bitmap[0]) / 255.0
        let green = CGFloat(bitmap[1]) / 255.0
        let blue = CGFloat(bitmap[2]) / 255.0
        let alpha = CGFloat(bitmap[3]) / 255.0
            
       return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // Schedule the asyncAfter task
    var workItems: [DispatchWorkItem] = []

    func animateCat(cat: SceneCat, duration: CFTimeInterval, completion: DispatchWorkItem) {
        if workItems.count > 0 {
            workItems.forEach { item in
                item.cancel()
            }
            workItems = []
        }
        
        let group = DispatchGroup()
        guard let highlightMaterial = cat.highlightMaterial,
              let finalMaterial = cat.material,
              let finalDiffuseImage = cat.materialDiffuseContent
        else {
            return
        }
        
        SCNTransaction.begin()
        cat.p?.geometry?.materials = [highlightMaterial, finalMaterial]
        SCNTransaction.commit()
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        highlightMaterial.diffuse.contents = CatColorAnimator.averageColor(image: finalDiffuseImage)
        SCNTransaction.commit()
        
        group.enter()
        let workItem1 = DispatchWorkItem {
            defer { group.leave() }
            cat.p?.geometry?.materials.removeFirst()
        }
        
        workItems = [workItem1, completion]
        
        // Execute work item 1
        Dispatch.DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem1)

        // Notify when work item 1 completes and execute work item 2
        group.notify(queue: .global(), work: completion)        
    }
}
