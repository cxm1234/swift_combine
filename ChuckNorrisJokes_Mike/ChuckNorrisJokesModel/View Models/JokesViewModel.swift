//
//  JokesViewModel.swift
//  ChuckNorrisJokesModel
//
//  Created by Mike_Tree on 10/8/24.
//

import Foundation
import SwiftUI
import Combine

public final class JokesViewModel: ObservableObject {
    public enum DecisionState {
        case disliked, undecided, liked
    }
    
    private static let decoder = JSONDecoder()
    
    @Published public var fetching = false
    @Published public var joke = Joke.starter
    @Published public var backgroundColor = Color("Gray")
    @Published public var decisionState = DecisionState.undecided
    
    private let jokesService: JokeServiceDataPublisher
    
    public init(jokesService: JokeServiceDataPublisher = JokesService()) {
        self.jokesService = jokesService
        
        $joke
            .map { _ in false }
            .assign(to: &$fetching)
    }
    
    public func fetchJoke() {
        fetching = true
        jokesService.publisher()
            .retry(1)
            .decode(type: Joke.self, decoder: Self.decoder)
            .replaceError(with: Joke.error)
            .receive(on: DispatchQueue.main)
            .assign(to: &$joke)
    }
    
    public func updateBackgroundColorForTranslation(_ translation: Double) {
        switch translation {
        case ...(-0.5):
            backgroundColor = Color("Red")
        case 0.5...:
            backgroundColor = Color("Green")
        default:
            backgroundColor = Color("Gray")
        }
    }
    
    public func updateDecisionStateForTranslation(
        _ translation: Double,
        andPredictedEndLocationX x: CGFloat,
        inBounds bounds: CGRect
    ) {
        switch (translation, x) {
        case (...(-0.6), ..<0):
            decisionState = .disliked
        case (0.6..., bounds.width...):
            decisionState = .liked
        default:
            decisionState = .undecided
        }
    }
    
    public func reset() {
        backgroundColor = Color("Gray")
    }
}
