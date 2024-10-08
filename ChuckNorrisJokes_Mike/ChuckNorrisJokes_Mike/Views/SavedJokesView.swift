//
//  SavedJokesView.swift
//  ChuckNorrisJokes_Mike
//
//  Created by Mike_Tree on 10/8/24.
//

import SwiftUI
import ChuckNorrisJokesModel

struct SavedJokesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \JokeManagedObject.value, ascending: true)],
        animation: .default
    )
    private var jokes: FetchedResults<JokeManagedObject>
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(jokes, id: \.self) { joke in
                        Text(joke.value ?? "N/A")
                    }
                    .onDelete { indices in
                        self.jokes.delete(
                            at: indices,
                            inViewContext: self.viewContext
                        )
                    }
                }
                .navigationBarTitle("Saved Jokes")
            }
        }
    }
}

#Preview {
    SavedJokesView()
}
