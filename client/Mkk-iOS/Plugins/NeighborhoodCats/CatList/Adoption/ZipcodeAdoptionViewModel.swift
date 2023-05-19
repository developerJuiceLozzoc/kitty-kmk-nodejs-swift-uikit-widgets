//
//  ZipcodeAdoptionViewModel.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 5/13/23.
//

import Foundation
import SceneKit
import SwiftUI
import Combine


enum ZipcodeAdoptions {}

extension ZipcodeAdoptions {
    typealias ViewModel = StateManagementViewModel<Observable, NonObservable, Action>
    
    struct Observable {
        var isBreedsLoading: Result<Bool, KMKNetworkError> = .success(false)
        var isSceneLoading: Result<Bool, KMKNetworkError> = .success(true)
    }
    
    struct NonObservable {
        var breed: KittyBreed?
        var token: ZipcodeCat
        // possible images for cat.
        // material thing comes from the
        var images: [URL]? = nil
        
        var scene = SCNScene(named: "cat")
        var sceneDelegate: SimpleSceneDelegate?
        var isSceneLoading: Result<Bool, KMKNetworkError> = .success(true)
    }
    
    enum Action {
        
    }
}

extension ZipcodeAdoptions.ViewModel {
    
    convenience init(with cat: ZipcodeCat) {
        self.init(observables: .init(), nonobservables: .init(token: cat))
        self.nonObservables.sceneDelegate = .init() { [weak self] (scene, startTime) in
            guard let self = self else { return }
            self.observables.isSceneLoading = .success(false)
        }
    }
    
}


extension ZipcodeAdoptions.ViewModel {
    
    func getDetailsCall() {
        // first fetch the breed
        // then fetch images
    }
    
}
