//
//  CollageNeue_MikeApp.swift
//  CollageNeue_Mike
//
//  Created by ming on 2024/8/16.
//

import SwiftUI

@main
struct CollageNeue_MikeApp: App {
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(CollageNeueModel())
        }
    }
}
