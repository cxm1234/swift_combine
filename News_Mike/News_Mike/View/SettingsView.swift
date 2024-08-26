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
    @State var presentingAddKeywordSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Filter keywords")) {
                    ForEach([FilterKeyword]()) { keyword in
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
                }
            }
            .sheet(isPresented: $presentingAddKeywordSheet, content: {
                AddKeywordView { newKeyword in
                    
                }
                .frame(minHeight: 0, maxHeight: 400, alignment: .center)
            })
            .navigationBarTitle(Text("Settings"))
            .navigationBarItems(trailing: SettingsBarItems(add: addKeyword))
        }
    }
    
    private func addKeyword() {
        
    }
    
    private func moveKeyword(from source: IndexSet, to destination: Int) {
        
    }
    
    private func deleteKeyword(at index: IndexSet) {
        
    }
}
