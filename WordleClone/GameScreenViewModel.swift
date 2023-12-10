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
        print("Answer: \(answer)")
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
            setCellBackgroundColours()
            currentRowIndex += 1
            currentGuess = ""
        }
    }
        
    private func isValid(word: String) -> Bool {
        MockData.wordBank.contains(word.lowercased())
    }
    
    func setCellBackgroundColours() {
        currentGuess.enumerated().forEach { index, letter in
            print(currentRowIndex*Self.numberOfColumns + index)
            gridCellModels[gridIndexFromCurrentGuessLetterIndex(index)].backgroundColour = getCellBackgroundColour(index: index, letter: letter)
        }
    }
    
    func getCellBackgroundColour(index: Int, letter: Character) -> Color {
        let answerArray = Array(answer)
        if answerArray[index] == letter {
            return ColourManager.letterInCorrectPosition
        }
        if answerArray.contains(letter) {
            return ColourManager.letterInWrongPosition
        }
        return ColourManager.letterNotInAnswer
    }
    
    private func gridIndexFromCurrentGuessLetterIndex(_ letterIndex: Int) -> Int {
        currentRowIndex*Self.numberOfColumns + letterIndex
    }

    
}
