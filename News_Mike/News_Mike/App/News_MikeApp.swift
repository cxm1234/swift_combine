//
//  News_MikeApp.swift
//  News_Mike
//
//  Created by ming on 2024/8/20.
//

import SwiftUI
import Combine

@main
struct News_MikeApp: App {
    let userSettings = Settings()
    private var subscriptions = Set<AnyCancellable>()
    let viewModel = ReaderViewModel()
    
    init() {
        userSettings.$keywords
            .map { $0.map { $0.value }}
            .assign(to: \.filter, on: viewModel)
            .store(in: &subscriptions)
    }
    
    var body: some Scene {
        WindowGroup {
            ReaderView(model: viewModel)
                .environmentObject(userSettings)
                .onAppear(perform: {
                    viewModel.fetchStories()
                })
        }
    }
}
