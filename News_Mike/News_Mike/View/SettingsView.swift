//
//  SettingsView.swift
//  News_Mike
//
//  Created by ming on 2024/8/25.
//

import SwiftUI

fileprivate struct SettingsBarItems: View {
    let add: () -> Void
    var body: some View {
        HStack(spacing: 20) {
            Button(action: add) {
                Image(systemName: "plus")
            }
            EditButton()
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @State var presentingAddKeywordSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Filter keywords")) {
                    ForEach(settings.keywords) { keyword in
                        HStack(alignment: .top) {
                            Image(systemName: "star")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .scaleEffect(0.67)
                                .background(.yellow)
                                .cornerRadius(5)
                            Text(keyword.value)
                        }
                    }
                    .onDelete(perform: deleteKeyword(at:))
                    .onMove(perform: moveKeyword(from:to:))
                }
            }
            .sheet(isPresented: $presentingAddKeywordSheet, content: {
                AddKeywordView { newKeyword in
                    let new = FilterKeyword(value: newKeyword.lowercased())
                    self.settings.keywords.append(new)
                    self.presentingAddKeywordSheet = false
                }
                .frame(minHeight: 0, maxHeight: 400, alignment: .center)
            })
            .navigationBarTitle(Text("Settings"))
            .navigationBarItems(trailing: SettingsBarItems(add: addKeyword))
        }
    }
    
    private func addKeyword() {
        presentingAddKeywordSheet = true
    }
    
    private func moveKeyword(from source: IndexSet, to destination: Int) {
        guard let source = source.first, destination != settings.keywords.endIndex else {
            return
        }
        
        settings.keywords.swapAt(
            source,
            source > destination ? destination : destination - 1
        )
    }
    
    private func deleteKeyword(at index: IndexSet) {
        guard let index = index.first else {
            return
        }
        settings.keywords.remove(at: index)
    }
}
