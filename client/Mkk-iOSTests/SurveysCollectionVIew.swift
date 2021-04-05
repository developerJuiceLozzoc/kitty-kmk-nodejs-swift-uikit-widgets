//
//  SurveysCollectionVIew.swift
//  Mkk-iOSTests
//
//  Created by Conner M on 4/4/21.
//

import XCTest

class mockStatLoader:StatModelLoader  {
    func loadPageOfCelebs(type: Int, offset: Int,amount: Int,completion: @escaping (Result<CelebResults,KMKNetworkError>)->Void){
        guard let path = Bundle(for: Self.self).path(forResource: "sample_survey", ofType: "json") else {
            completion(.failure(.urlError))
            return
        }
        let url = URL(fileURLWithPath: path, isDirectory: false)
        do{
            guard let data = try? Data(contentsOf: url) else {
                completion(.failure(.urlError))
                return
            }
            let decoded = try JSONDecoder().decode(CelebResults.self, from:data )
            completion(.success(decoded))
            
        }
        catch let _{
            completion(.failure(.decodeFail))
        }
    }
}

class SurveysCollectionVIew: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testModelStateAfterSegmentChange() throws {
        let network =  mockStatLoader()
        let viewmodel = CollectionViewModel()
        viewmodel.model = network
        
        let expectation = XCTestExpectation(description: "Should resolve json load")
        
        viewmodel.loadNextPage(type: 0) {
            print("before modifiecation",viewmodel.dataSource)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
        viewmodel.toggleBetweenSameSurveySource(with: 1)
        print("after modifiecation",viewmodel.dataSource)
        
    }


}
