//
//  SignupViewModel.swift
//  ModernMVVM
//
//  Created by Mounika Jakkampudi on 5/12/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import Combine

final class SignupViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}

// MARK: - Inner Types

extension SignupViewModel {
    enum State {
        case idle
        case loading
        case onLoginRequest(String, String)
        case loaded(SignUpDetails)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onLoginAction(String, String)
        case onSelectMovie(Int)
        case onLoginLoaded(SignUpDetails)
        case onFailedLogin(Error)
    }
    
    struct SignUpDetails {
        let message: String?
        let success: Bool?
        init(object: SignUpResponseObject) {
            message = object.message
            success = object.status
        }
    }
}

// MARK: - State Machine

extension SignupViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            case .onLoginAction(let username, let password):
                return .onLoginRequest(username,password)
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedLogin(let error):
                return .error(error)
            case .onLoginLoaded(let movies):
                return .loaded(movies)
            case .onLoginAction(let username, let password):
                return .onLoginRequest(username,password)
            default:
                return state
            }
        case .loaded:
            return state
        case .onLoginRequest( _, _):
            switch event {
            case .onFailedLogin(let error):
                return .error(error)
            case .onLoginLoaded(let movies):
                return .loaded(movies)
            default:
                return state
            }
        case .error:
            return state
        }
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .onLoginRequest(let username, let password) = state else { return Empty().eraseToAnyPublisher() }
            let params = ["login":username, "password":password, "firstname": "mahesh",
            "lastname": "somineni",
            "role": "user"]
            return API.signUp(bodyParams: params)
                .map(SignUpDetails.init)
                .map(Event.onLoginLoaded)
                .catch { Just(Event.onFailedLogin($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
