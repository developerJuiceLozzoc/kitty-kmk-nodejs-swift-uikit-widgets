//
//  ViewModel.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 4/15/23.
//

import Foundation


import Combine


@dynamicMemberLookup
public class StateManagementViewModel<Observable, NonObservable, Action>: ObservableObject {
    @Published public var observables: Observable
    public var nonObservables: NonObservable
    
    private var cancellables: Set<AnyCancellable> = []
    public let actionPublisher: PassthroughSubject<Action, Never>

    public init(
        observables: Observable,
        nonobservables: NonObservable,
        actionPublisher: PassthroughSubject<Action, Never> = .init()
    ) {
        self.observables = observables
        self.nonObservables = nonobservables
        self.actionPublisher = actionPublisher
    }
}


public extension StateManagementViewModel {
    
    subscript<T>(dynamicMember keyPath: KeyPath<Observable, T>) -> T {
        observables[keyPath: keyPath]
    }
    
    func addCancellable(_ cancellable: AnyCancellable) {
        cancellables.insert(cancellable)
    }
    
    @discardableResult
    func bindReceiveValue<P: Publisher, Input>(
        observables observablesPublisher: P,
        using update: @escaping (Input) -> Void
    ) -> Self where P.Output == Input, P.Failure == Never {
        observablesPublisher
            .sink(receiveValue: update)
            .store(in: &cancellables)
        return self
    }
    
}

public extension AnyCancellable {
    func store<Observable, NonObservable, Action>(in viewModel: StateManagementViewModel<Observable, NonObservable, Action>) {
        viewModel.addCancellable(self)
    }
}
