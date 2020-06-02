//
//  MovieDetailViewModel.swift
//  ModernMVVMList
//
//  Created by Vadim Bulavin on 3/19/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import Combine

final class MovieDetailViewModel: ObservableObject {
    @Published private(set) var state: State
    
    private var bag = Set<AnyCancellable>()
    
    private let input = PassthroughSubject<Event, Never>()
    
    init(movieID: Int) {
        state = .idle(movieID)
        
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
    
    func send(event: Event) {
        input.send(event)
    }
}

// MARK: - Inner Types

extension MovieDetailViewModel {
    enum State {
        case idle(Int)
        case loading(Int)
        case loaded(MovieDetail)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onLoaded(MovieDetail)
        case onFailedToLoad(Error)
    }
    
    struct MovieDetail {
        let id:Int
        let address:String
        let name:String
        let industry:String
        let thumbUrl:URL?
        let reviews: [ReviewsDTO]
        init(object: OrganizationDTO) {
            id = Int(object.id)!
            address = object.address
            name = object.name
            industry = object.industry
            thumbUrl = URL(string: object.thumb_url)
            reviews = object.reviews ?? [ReviewsDTO]()
        }
    }
}

// MARK: - State Machine

extension MovieDetailViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle(let id):
            switch event {
            case .onAppear:
                return .loading(id)
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoad(let error):
                return .error(error)
            case .onLoaded(let movie):
                return .loaded(movie)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading(let id) = state else { return Empty().eraseToAnyPublisher() }
            return API.getOriganizationDetail(id: id)
                .map(MovieDetail.init)
                .map(Event.onLoaded)
                .catch { Just(Event.onFailedToLoad($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback(run: { _ in
            return input
        })
    }
}
