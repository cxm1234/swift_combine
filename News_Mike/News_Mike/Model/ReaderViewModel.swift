//
//  ReaderViewModel.swift
//  News_Mike
//
//  Created by ming on 2024/8/20.
//

import Foundation
import Combine

class ReaderViewModel: ObservableObject {
    private let api = API()
    @Published private var allStories = [Story]()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var filter = [String]()
    
    var stories: [Story] {
        guard !filter.isEmpty else {
            return allStories
        }
        return allStories
            .filter { story -> Bool in
                return filter.reduce(false) { isMatch, keyword in
                    return isMatch || story.title.lowercased().contains(keyword)
                }
            }
    }
    
    @Published var error: API.Error? = nil 
    
    func fetchStories() {
        api
            .stories()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { stories in
                self.allStories = stories
                self.error = nil
            }
            .store(in: &subscriptions)
    }
}
