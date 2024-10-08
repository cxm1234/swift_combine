//
//  JokeServiceDataPublisher.swift
//  ChuckNorrisJokesModel
//
//  Created by Mike_Tree on 10/8/24.
//

import Foundation
import Combine

public protocol JokeServiceDataPublisher {
    func publisher() -> AnyPublisher<Data, URLError>
}


