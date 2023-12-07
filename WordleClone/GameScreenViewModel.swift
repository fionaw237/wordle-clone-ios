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
    var currentGuess = ""
    var currentRowIndex = 0
    var currentLetterIndex: Int { (currentRowIndex * Self.numberOfColumns) + currentGuess.count }
    
    var isRowFull: Bool {
        currentGuess.count == 5
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
            currentGuess += letter.lowercased()
        }
    }
    
    func deleteKeyPressed() {
        guard currentGuess.isNotEmpty else { return }    
        currentGuess.removeLast()
        gridCellModels[currentLetterIndex].letter = ""
    }
    
    func enterKeyPressed() {
        if isRowFull && isValid(word: currentGuess) {
            currentRowIndex += 1
            currentGuess = ""
        }
    }
    
    private func isValid(word: String) -> Bool {
        MockData.wordBank.contains(word.lowercased())
    }
    
}
