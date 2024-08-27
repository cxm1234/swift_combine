//
//  JSONFile.swift
//  News_Mike
//
//  Created by ming on 2024/8/27.
//

import Foundation

struct JSONFile {
    private static let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    
    static func loadValue<T: Codable>(named name: String) throws -> T {
        let fileURL = URL(fileURLWithPath: libraryPath).appendingPathComponent("\(name).json")
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func save<T: Codable>(value: T, named name: String) throws {
        let data = try JSONEncoder().encode(value)
        let fileURL = URL(fileURLWithPath: libraryPath).appendingPathComponent("\(name).json")
        try data.write(to: fileURL)
    }
}
