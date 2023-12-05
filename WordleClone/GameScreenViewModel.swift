//
//  GameScreenViewModel.swift
//  WordleClone
//
//  Created by Fiona Wilson on 01/12/2023.
//

import Foundation
import SwiftUI

final class GameScreenViewModel: ObservableObject {
    
    static let numberOfGridCells = 30
    static let numberOfColumns = 5
    
    let wordGenerator: WordGeneratorProtocol
    
    init(wordGenerator: WordGeneratorProtocol) {
        self.wordGenerator = wordGenerator
    }
    
    var answer: String = ""
    var currentRowIndex = 0
    var lettersEnteredInRow = 0
    var currentLetterIndex: Int {
        (currentRowIndex * Self.numberOfColumns) + lettersEnteredInRow
    }
    var currentGuess: String {
        let firstLetterIndex = (currentLetterIndex - 5)
        return (firstLetterIndex...currentLetterIndex).reduce("") { partialResult, index in
            partialResult + gridCellModels[index].letter.lowercased()
        }
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
        guard let generatedAnswer = wordGenerator.generateWord() else { return }
        answer = generatedAnswer
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
    
    func enterKeyPressed() {
        if isRowFull && isValid(word: currentGuess) {
            currentRowIndex += 1
            lettersEnteredInRow = 0
        }
    }
    
    private func isValid(word: String) -> Bool {
        MockData.wordBank.contains(word)
    }
    
}

