//
//  GameSurveyVM.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/12/21.
//

import Foundation


class GameSurveyVM {
    var survey: GameSurvey? {
        didSet {
            print(survey) 
        }
    }
    weak var observer: NSObjectProtocol?
    private var model = GameSurveyModel()
    init(with survey: GameSurvey){
        self.survey = survey
    }
    func saveGameResults(completion: ()->Void){
//        post to server/
        completion()
    }
    
    func listenToVoteChanges(){
        DispatchQueue.global().async {
            self.observer = NotificationCenter.default.addObserver(forName: .voteDidChange, object: nil, queue: .current, using: { [weak self] (notification) in
                
                guard let self = self else {return}
                guard let payload = notification.object as? VoteIdentity else {return}
                print(payload.entity,payload.value)
                
                guard let index = self.survey?.votes.firstIndex(of: payload.value) else {return}
                self.survey?.votes.swapAt(payload.entity, index)
                guard let votes = self.survey?.votes else {return}
                
                NotificationCenter.default.post(
                    name: .radiobttnUpdate,
                    object: SwapRadioButtons(
                        swap: VoteIdentity(
                            entity: payload.entity,
                            value: votes[payload.entity]),
                        with: VoteIdentity(
                            entity: index,
                            value: votes[index])
                        )
                )
            })
        }
       
        
    }
    func stopListenToVoteChanges(){
        NotificationCenter.default.removeObserver(observer)
    }
    
}
