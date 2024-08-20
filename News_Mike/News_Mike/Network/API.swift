//
//  API.swift
//  News_Mike
//
//  Created by ming on 2024/8/20.
//

import Foundation
import Combine

struct API {
    enum Error: LocalizedError, Identifiable {
        
        var id: String { localizedDescription }
        
        case addressUnreachable(URL)
        case invalidResponse
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse: return "The server responded with garbage"
            case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
            }
        }
    }
    
    enum EndPoint {
        static let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0/")!
        
        case stories
        case story(Int)
        
        var url: URL {
            switch self {
            case .stories:
                return EndPoint.baseURL.appendingPathComponent("newstories.json")
            case .story(let id):
                return EndPoint.baseURL.appendingPathComponent("item/\(id).json")
            }
        }
    }
    
    var maxStories = 10
    
    private let decoder = JSONDecoder()
    
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
    
    func story(id: Int) -> AnyPublisher<Story, Error> {
        URLSession.shared
            .dataTaskPublisher(for: EndPoint.story(id).url)
            .receive(on: apiQueue)
            .map(\.data)
            .decode(type: Story.self, decoder: decoder)
            .catch { _ in
                Empty<Story, Error>()
            }
            .eraseToAnyPublisher()
    }
    
    func mergedStories(ids storyIDs: [Int]) -> AnyPublisher<Story, Error> {
        let storyIDs = Array(storyIDs.prefix(maxStories))
        let initialPublisher = story(id: storyIDs[0])
        let remainder = Array(storyIDs.dropFirst())
        return remainder.reduce(initialPublisher) { combined, id in
            return combined.merge(with: story(id: id))
                .eraseToAnyPublisher()
        }
    }
    
    func stories() -> AnyPublisher<[Story], Error> {
        URLSession.shared
            .dataTaskPublisher(for: EndPoint.stories.url)
            .map(\.data)
            .decode(type: [Int].self, decoder: decoder)
            .mapError { error -> API.Error in
                switch error {
                case is URLError:
                    return Error.addressUnreachable(EndPoint.stories.url)
                default:
                    return Error.invalidResponse
                }
            }
            .filter { !$0.isEmpty }
            .flatMap { storyIDs in
                return self.mergedStories(ids: storyIDs)
            }
            .scan([]) { stories, story in
                return stories + [story]
            }
            .map { $0.sorted() }
            .eraseToAnyPublisher()
    }
}
