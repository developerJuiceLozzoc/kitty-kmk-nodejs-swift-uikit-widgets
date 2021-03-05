//
//  GameSurveyVM.swift
//  Mkk-iOS
//
//  Created by Conner M on 2/12/21.
//

import Foundation


class GameSurveyVM {
    var survey: GameSurvey?
    weak var observer: NSObjectProtocol?
    private var model = GameSurveyModel()
    var updatehandler: ( ()-> Void )?
    
    func bind( handler: @escaping ( () -> Void ) ){
        updatehandler = handler
    }
    
    init(with survey: GameSurvey){
        self.survey = survey
    }
    func saveGameResults(){
//        post to server/
        guard let survey = self.survey else {return}
        model.submitGameResult(with: survey) { (result) in
            switch result {
            case .success(let survey):
                self.survey = survey
                self.updatehandler?()
                break;
            case .failure(let err):
                print(err)
                break
            }
        }
      
    }
    
    func listenToVoteChanges(){
        guard observer == nil else {return}
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
        observer = nil
    }
    
}

//MARK: Implmenting survey  confirmation datasource
extension GameSurveyVM: KMKSurveyConfirmationDataSource {
    func getLabelForCeleb(at index: Int) -> String {
        guard let survey = self.survey else {return VOTE_LIST[index]}
        return VOTE_LIST[survey.votes[index]]
    }
    
    
}

