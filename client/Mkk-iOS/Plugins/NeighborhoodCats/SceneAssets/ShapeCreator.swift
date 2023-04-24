//
//  ShapeCreator.swift
//  SKPresentation
//
//  Created by Conner M on 1/29/21.
//
import SceneKit


struct ORrxForm {
    var numberOfSpawn: Int = 10
    var shape:  String = "CUBE"
    var gold = UIColor(named: "gold")!
    var pink = UIColor(named: "pink")!
}

class ShapeCreator {
    private func randomVelocity(multiplier velmul: Float) -> SCNVector3 {
        
        let randomPHI = Float.random(in: 0...3.14159/4 )
        let randomRHO = Float.random(in: 0...3.14159)
        
        let x: Float = velmul/2 * cos(randomRHO)
        let y: Float = velmul*4 * sin(randomPHI)
        let z: Float = velmul/2 * sin(randomRHO)
        
        return SCNVector3(x, y, z)
    }
    
    func spawnProjectile(named id: String, multiplier velmul: Float = 2,offset pos: SCNVector3) -> SCNNode {
        let sphereGeometry = SCNSphere(radius: 0.25)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(systemName: "globe")
        sphereGeometry.materials = [material]
        
        let projectileNode = SCNNode(geometry: sphereGeometry)
        projectileNode.name = "SPAWNED-projectile-\(id)"
        
        projectileNode.physicsBody = .dynamic()
        
        let vel = randomVelocity(multiplier: velmul)
        projectileNode.physicsBody?.applyForce(vel, asImpulse: true)
        projectileNode.position = pos
        return projectileNode
        
    }
    func spawnNode(with form: ORrxForm) -> SCNNode{
        switch form.shape {
            case "CUBE":
                return spawnCube(with: form)
            case "GLOBE":
                return spawnSphere(with: form)
            case "PYRAMID":
                return spawnPyramid(with: form)
            default:
                return spawnCube(with: form)
        }
    }
    
    
    
    
    
    private func spawnCube(with form: ORrxForm) -> SCNNode {
        let cubeGeometry = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0.0)
        
        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = form.gold
        
        let bMaterial = SCNMaterial()
        bMaterial.diffuse.contents = form.pink
        
        cubeGeometry.materials = [redMaterial,bMaterial]
        
        let cubeNode = SCNNode(geometry: cubeGeometry)
        
        
        return cubeNode
    }
    private func spawnSphere(with form: ORrxForm) -> SCNNode {
        let cubeGeometry = SCNSphere(radius: 2)
        
        let redMaterial = SCNMaterial()
//        redMaterial.diffuse.
        redMaterial.diffuse.contents = form.gold
        
        let bMaterial = SCNMaterial()
        bMaterial.diffuse.contents = form.pink
        
        cubeGeometry.materials = [redMaterial,bMaterial]
        
        let cubeNode = SCNNode(geometry: cubeGeometry)
        
        
        return cubeNode
    }
    private func spawnPyramid(with form: ORrxForm) -> SCNNode {
        let triGeometry = SCNPyramid(width: 2, height: 2, length: 2)
        
        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = form.gold
        
        let bMaterial = SCNMaterial()
        bMaterial.diffuse.contents = form.pink
        
        triGeometry.materials = [redMaterial,bMaterial]
        
        let pyrNode = SCNNode(geometry: triGeometry)
        
        pyrNode.eulerAngles = SCNVector3(x: 0, y: 0, z: 180)
        return pyrNode
    }
}
