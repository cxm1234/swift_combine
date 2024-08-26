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
    let viewModel = ReaderViewModel()
    
    var body: some Scene {
        WindowGroup {
            ReaderView(model: viewModel)
                .onAppear(perform: {
                    viewModel.fetchStories()
                })
        }
    }
}
