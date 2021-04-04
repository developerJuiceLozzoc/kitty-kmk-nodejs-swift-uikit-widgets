//
//  Protocols.swift
//  Mkk-iOS
//
//  Created by Conner M on 4/2/21.
//

import UIKit

protocol CatApier {
    func getJsonByBreed(with breed: String, completion: @escaping (Result<[KittyApiResults],KMKNetworkError>) -> Void)
    func getKittyImageByBreed(with breed: String, completion: @escaping (Result<UIImage,KMKNetworkError>) -> Void)
    func postNewNotification(withDeviceName name: String, completion: @escaping (Result<Bool,KMKNetworkError>)->Void)
}

protocol KMKSurveyConfirmationReader {
    func confirmSurvey()
    func getPhotoForVote(at index: Int) -> UIImage?
}

protocol KMKUseViewModel: UIViewController {
    var votevm: GameSurveyVM? { get set }
    var imagesvm: ImagesViewModel? { get set}

}

protocol Loader {
    func load(url: URL, completion: @escaping (Result<UIImage,KMKNetworkError>) -> Void)
}

protocol KMKApi {
    func fetchNewGame(completion: @escaping (Result<GameSurvey,KMKNetworkError>)->Void)
    // after submitting one, we expect to complete another.
    func submitGameResult(with survey: GameSurvey, completion: @escaping (Result<GameSurvey,KMKNetworkError>) -> Void)

}

protocol ConfirmKittyable {
    func confirmAdoption()
}

typealias kittystuff = (pretty: String, value: String)

