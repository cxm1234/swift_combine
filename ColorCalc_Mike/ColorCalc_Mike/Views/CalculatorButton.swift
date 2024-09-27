//
//  CalculatorButton.swift
//  ColorCalc_Mike
//
//  Created by Mike_Tree on 9/27/24.
//

import SwiftUI

struct CalculatorButton: View {
    @ObservedObject var viewModel: CalculatorViewModel
    let text: String
    let color: Color
    
    var body: some View {
        Button(action: {
            self.viewModel.process(self.text)
        }, label: {
            Text(text)
                .font(Font.system(size: 48, weight: .regular, design: .monospaced))
                .foregroundColor(viewModel.contrastingColor)
        })
    }
    
    init(viewModel: CalculatorViewModel, text: String, color: Color = .white) {
        self.viewModel = viewModel
        self.text = text
        self.color = color
    }
}
