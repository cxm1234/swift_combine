//
//  JokeCardView.swift
//  ChuckNorrisJokes_Mike
//
//  Created by Mike_Tree on 10/8/24.
//

import SwiftUI

struct JokeCardView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                Text(Joke.starter.value)
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.2)
                    .allowsTightening(true)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .animation(.easeInOut)
            }
            .frame(width: min(300, bounds.width * 0.7), height: min(400, bounds.height * 0.6))
            .padding(20)
            .cornerRadius(20)
        }
    }
    
    private var bounds: CGRect { UIScreen.main.bounds }
    
    private var repeatingAnimation: Animation {
        Animation.linear(duration: 1)
            .repeatForever()
    }
}

#Preview {
    JokeCardView()
}
