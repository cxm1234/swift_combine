//
//  URLComponents.swift
//  ChuckNorrisJokesModel
//
//  Created by Mike_Tree on 10/8/24.
//

import Foundation

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }
    
}
