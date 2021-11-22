//
//  NetworkTests.swift
//  Mkk-iOSTests
//
//  Created by Conner M on 4/3/21.
//

import XCTest

class MockNetwork: CatApier {
    func dispatchNotificationsImmediately(completion: @escaping (Result<Void, KMKNetworkError>) -> Void) {
        
    }
    
    func fetchRemoteFeatureToggles(completion: @escaping (Result<ZeusFeatureToggles, KMKNetworkError>) -> Void) {
        
    }
    
    func postNewNotification(withDeviceName name: String, completion: @escaping (Result<Bool, KMKNetworkError>) -> Void) {
        completion(.success(true))
    }
    
    func getJsonByBreed(with breed: String, completion: @escaping (Result<[KittyApiResults], KMKNetworkError>) -> Void) {
        guard let path = Bundle(for: Self.self).path(forResource: "MockNetwork", ofType: "json") else {
            completion(.failure(.urlError)); return;
        }
        let fileURL = URL(fileURLWithPath: path)

        URLSession.shared.dataTask(with: fileURL){data,resp,err in
                if let error = err {
                    print (error)
                    completion(.failure(.invalidRequestError))
                    return
                }
                if let data = data {
                    do{
                        let swiftkitty = try JSONDecoder().decode([KittyApiResults].self, from: data)
                        completion(.success(swiftkitty))
                    }
                    catch let err{
                        print(err)
                        completion(.failure(.decodeFail))
                    }

                }else{
                    completion(.failure(.noBreedsFoundError))
                    
                }
        }.resume()
    }
    
    func getKittyImageByBreed(with breed: String, completion: @escaping (Result<UIImage, KMKNetworkError>) -> Void) {
        return
    }
    
    
}

class NetworkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodingKittyJson() throws {
        let api: CatApier = MockNetwork()
        let expectation = XCTestExpectation(description: "SHould resolve to success decoded")
        
        api.getJsonByBreed(with: "asdf") { (result) in
            switch result {
                case .success(let kitties):
                    expectation.fulfill()
                case .failure(let e):
                    print(e)
                    XCTFail()
            }
        }
        
        
        wait(for: [expectation], timeout: 1)
    }



}
