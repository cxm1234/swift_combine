//
//  TimeBadge.swift
//  News_Mike
//
//  Created by ming on 2024/8/24.
//

import SwiftUI

struct TimeBadge: View {
    private static var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short
        return f
    }()
    
    let time: TimeInterval
    
    var body: some View {
        Text(TimeBadge.formatter.string(from: Date(timeIntervalSince1970: time)))
            .font(.headline)
            .fontWeight(.heavy)
            .padding(10)
            .foregroundColor(.white)
            .background(Color.orange)
            .cornerRadius(6)
            .frame(idealWidth: 100)
            .padding(.bottom, 10)
    }
}
