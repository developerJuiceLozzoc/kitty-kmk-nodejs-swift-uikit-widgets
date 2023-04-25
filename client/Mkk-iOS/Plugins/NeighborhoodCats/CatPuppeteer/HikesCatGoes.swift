//
//  HikesCatGoes.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/24/23.
//

import SceneKit

enum HikesCatGoes: CaseIterable, Equatable {
    case mansionPath
    case apartments
    case bootlegDistrict
    
    var period: Float {
        switch self {
        case .apartments:
            return 0
        case .bootlegDistrict:
            return 0
        case .mansionPath:
            return 0
        }
    }
    
    var amplitude: Float {
        24.0
    }
    
    var normalTowardsSky: SCNVector3{
        .init(x: 0, y: 1, z: 0)
    }
    
    /*
     General Form of the Sine Function y = a sin b(x – h) + k
     a is the amplitude: vertical stretch or compression b is used to determine the period: 2π/b
     h is the phase shift: horizontal translation
     Since x represents an angle in degrees or radians, h will also be expressed in degrees or radians.
     k is the vertical translation
     Since y represents a number, k will also be expressed as a number.
     */
    func postion(time: Float) -> SCNVector3?
    {
        /* x ranges from 0 to pi */
        switch self {
        case .apartments:
            let nextX: (Float) -> Float = { time in
                (-26) / (Float.pi) * (time) + 43
            }
            let nextY: (Float) -> Float = { time in
                (-47) / (Float.pi) * (time) + 67
            }
            let nextZ: (Float) -> Float = { time in
                (281) / (Float.pi) * (time) + -335
            }
            return SCNVector3Make(nextX(time), nextY(time), nextZ(time))
        case .bootlegDistrict:
            let nextX: (Float) -> Float = { time in
                (229) / (Float.pi) * (time) + 17
            }
            let nextY: (Float) -> Float = { time in
                (78) / (Float.pi) * (time) + 20
            }
            let nextZ: (Float) -> Float = { time in
                (-169) / (Float.pi) * (time) + -54
            }
            return SCNVector3Make(nextX(time), nextY(time), nextZ(time))
        case .mansionPath:
            let nextX: (Float) -> Float = { time in
                (-156) / (Float.pi) * (time) + 43
            }
            let nextY: (Float) -> Float = { time in
                (-75) / (Float.pi) * (time) + 67
            }
            let nextZ: (Float) -> Float = { time in
                (120) / (Float.pi) * (time)  + -335
            }
            return SCNVector3Make(nextX(time), nextY(time), nextZ(time))
        }
    }
    
    func hikeCatIsHiking(at position: SCNVector3) -> Self? {
        return nil
    }
    
    var hikeForPath: CatHike {
        switch self {
        case .mansionPath:
            return (
                end1: .init(x: 43, y: 67, z: -335),
                end2: .init(x: -113, y: -8, z: -215)
            )
        case .apartments:
            return (
                end1: .init(x: 43, y: 67, z: -335),
                end2: .init(x: 17, y: 20, z: -54)
            )
        case .bootlegDistrict:
            return (
                end1: .init(x: 17, y: 20, z: -54),
                end2: .init(x: 246, y: 98, z: -223)
            )
        }
    }
}
