//
//  Story.swift
//  News_Mike
//
//  Created by ming on 2024/8/20.
//

import Foundation

public struct Story: Codable, Identifiable {
    public let id: Int
    public let title: String
    public let by: String
    public let time: TimeInterval
    public let url: String
}

extension Story: Comparable {
    public static func < (lhs: Story, rhs: Story) -> Bool {
        return lhs.time > rhs.time
    }
}

extension Story: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\n\(title)\nby \(by)\n\(url)\n-----"
    }
}
