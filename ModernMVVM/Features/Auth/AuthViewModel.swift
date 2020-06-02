//
//  MovieListViewModel.swift
//  ModernMVVMList
//
//  Created by Vadim Bulavin on 3/17/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
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

extension AuthViewModel {
    enum State {
        case idle
        case loading
        case onLoginRequest(String, String)
        case loaded(LoginDetails)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onLoginAction(String, String)
        case onSelectMovie(Int)
        case onLoginLoaded(LoginDetails)
        case onFailedLogin(Error)
    }
    
    struct LoginDetails {
        let id: String?
        let token: String?
        let role: String?
        let message: String?
        init(object: LoginResponseObject) {
            id = object.id
            token = object.token
            role = object.role
            message = object.message
        }
    }
}

// MARK: - State Machine

extension AuthViewModel {
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
            let params = ["login":username, "password":password]
            return API.login(bodyParams: params)
                .map(LoginDetails.init)
                .map(Event.onLoginLoaded)
                .catch { Just(Event.onFailedLogin($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
