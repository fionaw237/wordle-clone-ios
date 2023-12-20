//
//  LetterGridCellModel.swift
//  WordleClone
//
//  Created by Fiona Wilson on 05/12/2023.
//

import Foundation
import SwiftUI

enum LetterState {
    case unrevaled
    case notInWord
    case inWord
    case inWrongPosition
}

struct LetterGridCellModel: Identifiable {
    var id = UUID()
    var letter: String = ""
    var letterState: LetterState = .unrevaled
    var backgroundColour: Color { backgroundColourForLetterState() }
    var borderColour: Color? = .gray
    
    private func backgroundColourForLetterState() -> Color {
        switch letterState {
        case .unrevaled:
            return ColourManager.incompleteCell
        case .notInWord:
            return ColourManager.letterNotInAnswerCell
        case .inWord:
            return ColourManager.letterInCorrectPosition
        case .inWrongPosition:
            return ColourManager.letterInWrongPosition
        }
    }
}
