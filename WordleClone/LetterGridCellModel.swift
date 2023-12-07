//
//  LetterGridCellModel.swift
//  WordleClone
//
//  Created by Fiona Wilson on 05/12/2023.
//

import Foundation
import SwiftUI

enum LetterGuessedState {
    case notGuessed
    case notInAnswer
    case inAnswer
    case inWrongPostion
}

struct LetterGridCellModel: Identifiable {
    var id = UUID()
    var letter: String = ""
    var backgroundColour: Color = .white
    
    func colour(for guessedState: LetterGuessedState) -> Color {
        return .white
//        switch guessedState {
//        case .notGuessed, .notInAnswer:
//            return .white
//        case .inAnswer:
//            return .green
//        case .inWrongPostion:
//            return .yellow
//        }
    }
}
