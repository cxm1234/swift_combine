//
//  MockJokesService.swift
//  ChuckNorrisJokes_MikeTests
//
//  Created by Mike_Tree on 10/8/24.
//

import Foundation
import Combine
@testable import ChuckNorrisJokesModel

struct MockJokesService: JokeServiceDataPublisher {
    let data: Data
    let error: URLError?
    
    init(data: Data, error: URLError? = nil) {
        self.data = data
        self.error = error
    }
    
    func publisher() -> AnyPublisher<Data, URLError> {
        let publisher = CurrentValueSubject<Data, URLError>(data)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            if let error = error {
                publisher.send(completion: .failure(error))
            } else {
                publisher.send(data)
            }
        }
        return publisher.eraseToAnyPublisher()
    }
}
