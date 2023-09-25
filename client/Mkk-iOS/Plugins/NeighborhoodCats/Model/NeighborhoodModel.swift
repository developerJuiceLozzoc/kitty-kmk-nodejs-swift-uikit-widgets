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
    private var cancellables: Set<AnyCancellable> = .init()
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
    
    func fetchCats(from zipcode: String) {
        guard let url = URL(string: "\(SERVER_URL)/game/usazipcode/\(zipcode)") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: KMKNeighborhood.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                },
                receiveValue: { [weak self] result in
                    self?.neighborHoodPublisher?.send(.init(zipcode: "postalCode", cats: ZipcodeCat.previews))
                }
            )
            .store(in: &cancellables)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                if error != nil {
                    self.neighborHoodPublisher?.send(completion: .failure(.clientRejectedRequest))
                } else if let placemark = placemarks?.first {
                    if let postalCode = placemark.postalCode {
                        /* FIXME: query the api for the zipcode cat lols*/
                        self.neighborHoodPublisher?.send(.init(zipcode: postalCode, cats: ZipcodeCat.previews))
                    } else {
                        self.neighborHoodPublisher?.send(completion: .failure(.decodeFail))
                    }
                }
            }
        }
}

