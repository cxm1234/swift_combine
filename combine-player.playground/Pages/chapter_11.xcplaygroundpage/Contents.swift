//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Combine

struct API {
    enum Error: LocalizedError {
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
        URLSession.shared.dataTaskPublisher(for: EndPoint.story(id).url)
            .receive(on: apiQueue)
            .map(\.data)
            .decode(type: Story.self, decoder: decoder)
            
        return Empty().eraseToAnyPublisher()
    }
    
    
}

PlaygroundPage.current.needsIndefiniteExecution = true



//: [Next](@next)
