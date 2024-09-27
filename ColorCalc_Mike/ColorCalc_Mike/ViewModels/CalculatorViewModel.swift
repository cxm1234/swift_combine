//
//  CalculatorViewModel.swift
//  ColorCalc_Mike
//
//  Created by Mike_Tree on 9/27/24.
//

import Foundation
import SwiftUI
import Combine

final class CalculatorViewModel: ObservableObject {
    struct Constant {
        static let clear = "⊗"
        static let backspace = "←"
    }
    @Published var hexText = "#0080FF"
    @Published var name = "aqua (100%)"
    @Published var rgboText = "0, 128, 255, 255"
    @Published var color: Color = Color(
        .displayP3,
        red: 0,
        green: 128/255,
        blue: 1,
        opacity: 1
    )
    
    let buttonTextValues = [Constant.clear, "0", Constant.backspace] + (1...9).map { "\($0)" } + ["A", "B", "C", "D", "E", "F"]
    
    var contrastingColor: Color {
        color == .white ||
        hexText == "#FFFFFF" ||
        hexText.count == 9 && hexText.hasSuffix("00")
        ? .black : .white
    }
    
    func process(_ input: String) {
        switch input {
        case Constant.clear:
            break
        case Constant.backspace:
            if hexText.count > 1 {
                hexText.removeLast(2)
            }
        case _ where hexText.count < 9:
            hexText += input
        default:
            break
        }
    }
    
    init() {
        configure()
    }
    
    private func configure() {
        let hexTextShared = $hexText.share()
        hexTextShared
            .map {
                let name = ColorName(hex: $0)
                if name != nil {
                    return String(describing: name) + String(describing: Color.opacityString(forHex: $0))
                } else {
                    return "------------"
                }
            }
            .assign(to: &$name)
        
        let colorValuesShared = hexTextShared
            .map { hex -> (Double, Double, Double, Double)? in
                Color.redGreenBlueOpacity(forHex: hex)
            }
            .share()
        
        colorValuesShared
            .map { $0 != nil ? Color(values: $0!) : .red}
            .assign(to: &$color)
        
        colorValuesShared
            .map { values -> String in
                if let values = values {
                    return [values.0, values.1, values.2, values.3]
                        .map { String(describing: Int($0 * 155))}
                        .joined(separator: ", ")
                } else {
                    return "---, ---, ---, ---"
                }
            }
            .assign(to: &$rgboText)
    }
}
