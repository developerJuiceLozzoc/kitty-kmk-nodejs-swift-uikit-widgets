//
//  NeighborhoodModel.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/30/23.
//

import Combine
import SwiftUI
import MapKit

class NeighborhoodModel: NSObject {
    private var locationManager: CLLocationManager?
    private var neighborHoodPublisher: PassthroughSubject<KMKNeighborhood, KMKNetworkError>?
    
//    convenience init() {
//        self.init()
//    }
    
    func queryZipCode() -> AnyPublisher<KMKNeighborhood, KMKNetworkError> {
        let subject = PassthroughSubject<KMKNeighborhood, KMKNetworkError>()
        self.neighborHoodPublisher = subject
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestLocation()
        return subject.eraseToAnyPublisher()
    }
}


extension NeighborhoodModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.neighborHoodPublisher?.send(completion: .failure(.decodeFail))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                if let error = error {
                    self.neighborHoodPublisher?.send(completion: .failure(.clientRejectedRequest))
                } else if let placemark = placemarks?.first {
                    if let postalCode = placemark.postalCode {
                        self.neighborHoodPublisher?.send(.init(zipcode: postalCode, cats: ZipcodeCat.previews))
                    } else {
                        self.neighborHoodPublisher?.send(completion: .failure(.decodeFail))
                    }
                }
            }
        }
}

