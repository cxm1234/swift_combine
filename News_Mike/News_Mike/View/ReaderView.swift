//
//  ReaderView.swift
//  News_Mike
//
//  Created by ming on 2024/8/20.
//

import SwiftUI

struct ReaderView: View {
    var model: ReaderViewModel
    var presentingSettingsSheet = false
    
    var currentDate = Date()
    
    init(model: ReaderViewModel) {
        self.model = model
    }
    
    var body: some View {
        let filter = "Showing all stories"
        
        return NavigationView {
            List {
                Section(header: Text(filter).padding(.leading, -10)) {
                    ForEach(self.model.stories) { story in
                        VStack(alignment: .leading, spacing: 10) {
                            
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}
