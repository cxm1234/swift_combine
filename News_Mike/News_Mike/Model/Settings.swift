//
//  Settings.swift
//  News_Mike
//
//  Created by ming on 2024/8/20.
//

import Foundation
import Combine

fileprivate let keywordsFile = "filterKeywords"

final class Settings: ObservableObject {
    init() {
        if let storedKeywords: [FilterKeyword] = try? JSONFile.loadValue(named: keywordsFile) {
            self.keywords = storedKeywords
        }
    }
    @Published var keywords = [FilterKeyword]() {
        didSet {
            try? JSONFile.save(value: keywords, named: keywordsFile)
        }
    }
}
