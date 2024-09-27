//
//  CalculatorView.swift
//  ColorCalc_Mike
//
//  Created by ming on 2024/9/19.
//

import SwiftUI

struct CalculatorView: View {
    @ObservedObject private var viewModel = CalculatorViewModel()
    private var bounds: CGRect { return UIScreen.main.bounds }
    var body: some View {
        VStack {
            Spacer()
            DisplayView(viewModel: viewModel, type: .hex, width: bounds.width)
            HStack {
                DisplayView(viewModel: viewModel, type: .rgb, width: bounds.width / 2)
                DisplayView(viewModel: viewModel, type: .name, width: bounds.width / 2)
            }
            
            
        }
    }
}

struct ButtonRows: View {
    @ObservedObject var viewModel: CalculatorViewModel
    
    private var range: Range<Int> {
        0..<(viewModel.buttonTextValues.count / 3)
    }
    
    var body: some View {
        ForEach(range) { row in
            Spacer()
            ButtonRow(viewModel: viewModel, row: row)
            Spacer()
        }
    }
    
    
}

struct ButtonRow: View {
    @ObservedObject var viewModel: CalculatorViewModel
    let row: Int
    private var buttonTextValues: [String] {
        viewModel.buttonTextValues
    }
    var body: some View {
        HStack {
            Spacer()
            CalculatorButton(
                viewModel: viewModel,
                text: buttonTextValues[0 + (3 * row)]
            )
            Spacer()
            CalculatorButton(
                viewModel: viewModel,
                text: buttonTextValues[1 + (3 * row)]
            )
            Spacer()
            CalculatorButton(
                viewModel: viewModel,
                text: buttonTextValues[2 + (3 * row)]
            )
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

#Preview {
    CalculatorView()
}
