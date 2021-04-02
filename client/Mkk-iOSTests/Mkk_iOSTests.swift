//
//  Mkk_iOSTests.swift
//  Mkk-iOSTests
//
//  Created by Conner M on 4/2/21.
//

import XCTest

class Mkk_iOSTests: XCTestCase {
    
    var initalSurvey: GameSurvey!
    var vm: GameSurveyVM!

    override func setUpWithError() throws {
        initalSurvey = GameSurvey(_id: "dummy id", celebs: [
            Celebrity(name: "Steve", imgurl: "https://placekitten.com/400/400", _id: "0"),
            Celebrity(name: "William", imgurl: "https://placekitten.com/160/90", _id: "1"),
            Celebrity(name: "Arny", imgurl: "https://placekitten.com/400/600", _id: "2"),
        ])


        vm = GameSurveyVM(with: initalSurvey)
        vm.listenToVoteChanges()
    }

    override func tearDownWithError() throws {
        vm.stopListenToVoteChanges()
    }

    func testVoteChange() throws {
       
        XCTAssertTrue(vm.survey!.votes == [0,1,2])
        let vote = VoteIdentity(entity: 0, value: 2)
        NotificationCenter.default.post(name: .voteDidChange,object: vote)
        XCTAssertTrue(vm.survey!.votes == [2,1,0])
        
    }

    func testVoteClickSameButton() throws {
        let vote = VoteIdentity(entity: 0, value: 0)
        NotificationCenter.default.post(name: .voteDidChange,object: vote)
        XCTAssertTrue(vm.survey!.votes == [0,1,2])
    }
    
    
    
    func testSurveyReceivesCorrectPhotos() throws {
        
        
        let vote = VoteIdentity(entity: 0, value: 2)
        NotificationCenter.default.post(name: .voteDidChange,object: vote)
        // votes should be [2,1,0] which means we should be getting the [2] photo
        var celeb = getPhotoForVote(at: 0)
        XCTAssertTrue(celeb?.imgurl == "https://placekitten.com/400/600")
        celeb = getPhotoForVote(at: 1)
        XCTAssertTrue(celeb?.imgurl == "https://placekitten.com/160/90")
        celeb = getPhotoForVote(at: 2)
        XCTAssertTrue(celeb?.imgurl == "https://placekitten.com/400/400")

//        XCTAssertTrue(photo!.accessibilityIdentifier! == "https://placekitten.com/400/400")
    }
    
    

}
extension Mkk_iOSTests {
    func getPhotoForVote(at index: Int) -> Celebrity? {

        guard let i = vm.survey?.votes[index] else {return nil}
        return vm.survey?.celebs[i]

    }
    
    func confirmSurvey() {
       return
    }
    
    
}
