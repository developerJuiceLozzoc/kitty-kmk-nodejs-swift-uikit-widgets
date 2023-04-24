//
//  CatPuppeteer.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/19/23.
//

import SceneKit

typealias CatHike = (end1: SCNVector3, end2: SCNVector3)
/* this makes action on a scene and will render a cat walking
 each render. They will stick to bumping around */

enum HikesCatGoes: CaseIterable {
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
//            var pathEquation: (Float) -> SCNVector3 = { x in
//                let result = amplitude * sin(x * period)
//
//            }
            return nil
        case .bootlegDistrict:
            return nil
        case .mansionPath:
            return nil
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
    /*
     mansion
     time = 0, z = -335; time = pi, z = -215.
     z = 

     time = 0, y = 67; time = pi, y = -8.

     time = 0, x = 43; time = pi, x = -113

     
     apartments
     time = 0, z = -335; time = pi, z = -54.

     time = 0, y = 67; time = pi, y = 20.

     time = 0, x = 43; time = pi, x = 17

     bootlegdistrict
     time = 0, z = -54; time = pi, z = -223.

     time = 0, y = 20; time = pi, y = 98.

     time = 0, x = 17; time = pi, x = 246
     */
}
