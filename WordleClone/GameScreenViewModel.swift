//
//  GameScreenViewModel.swift
//  WordleClone
//
//  Created by Fiona Wilson on 01/12/2023.
//

import Foundation
import SwiftUI

struct LetterGridCellModel: Identifiable {
    var id = UUID()
    var letter: String = ""
    var backgroundColour: Color = .white
}

final class GameScreenViewModel: ObservableObject {
    
    static let numberOfGridCells = 30
    
    var answer: String = ""
    var currentRowIndex = 0
    var lettersEnteredInRow = 0
    var currentLetterIndex: Int {
        currentRowIndex * lettersEnteredInRow + lettersEnteredInRow
    }
    
    var isRowFull: Bool {
        lettersEnteredInRow == 5
    }

    @Published var gridCellModels: [LetterGridCellModel] = {
        // return Array(repeating: GuessedLetter(), count: 30)
        // is not working for some reason so using this
        // alternative approach
        var result: [LetterGridCellModel] = []
        for i in 0..<numberOfGridCells {
            result.append(LetterGridCellModel())
        }
        return result
    }()
    
    func newGame() {
        guard let generatedAnswer = generateAnswer() else { return }
        answer = generatedAnswer
    }
    
    func generateAnswer() -> String? {
        return MockData.wordBank.randomElement()
    }
    
    func letterKeyPressed(_ letter: String) {
        if !isRowFull {
            gridCellModels[currentLetterIndex] = LetterGridCellModel(letter: letter)
            lettersEnteredInRow += 1
        }
    }
    
    func deleteKeyPressed() {
        guard lettersEnteredInRow > 0 else { return }
        lettersEnteredInRow -= 1
        gridCellModels[currentLetterIndex].letter = ""
    }
        
}

