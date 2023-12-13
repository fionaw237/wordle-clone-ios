//
//  GameScreenViewModel.swift
//  WordleClone
//
//  Created by Fiona Wilson on 01/12/2023.
//

import Foundation
import SwiftUI

struct KeyboardLetterKeyModel: Identifiable {
    var id = UUID()
    var value: String
    var isDisabled: Bool = false
    var onPress: () -> Void
    var backgroundColour: Color = .gray {
        didSet {
            if backgroundColour == ColourManager.letterNotInAnswerKeyboard {
                isDisabled = true
            }
        }
    }
}

final class GameScreenViewModel: ObservableObject {
    
    static let numberOfGridCells = 30
    static let numberOfColumns = 5
    
    let gridColumns: [GridItem] = [
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem()
    ]
    
    var letterKeyModels: [KeyboardLetterKeyModel] = []
    
    let wordGenerator: WordGeneratorProtocol
    
    init(wordGenerator: WordGeneratorProtocol) {
        self.wordGenerator = wordGenerator
        initialiseKeyboard()
    }
    
    private func initialiseKeyboard() {
        let letters = "QWERTYUIOPASDFGHJKLZXCVBNM"
        letterKeyModels = letters.map { letter in
            let stringValue = String(letter)
            return KeyboardLetterKeyModel(value: stringValue, onPress: { self.letterKeyPressed(stringValue) })
        }
    }
    
    var answer: String = ""
    var currentGuess = ""
    var currentRowIndex = 0
    var currentLetterIndex: Int { (currentRowIndex * Self.numberOfColumns) + currentGuess.count }
    
    var isRowFull: Bool {
        currentGuess.count == 5
    }
    var isGameFinished: Bool {
        (currentGuess == answer) || (currentRowIndex == 5)
    }
    
    @Published var showGameCompletedModal = false

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
    
    func getInitialGridCells() -> [LetterGridCellModel] {
        // return Array(repeating: GuessedLetter(), count: 30)
        // is not working for some reason so using this
        // alternative approach
        var result: [LetterGridCellModel] = []
        for _ in 0..<Self.numberOfGridCells {
            result.append(LetterGridCellModel())
        }
        return result
        
    }
    
    func newGame() {
        guard let generatedAnswer = wordGenerator.generateWord() else { return }
        answer = generatedAnswer
        print("Answer: \(answer)")
    }
    
    func resetGrid() {
        currentGuess = ""
        currentRowIndex = 0
        gridCellModels = getInitialGridCells()
        initialiseKeyboard()
        newGame()
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
            setKeyboardKeyBackgroundColours()
            if isGameFinished {
                showGameCompletedModal = true
            } else {
                moveToNextRow()
            }
        }
    }
        
    private func isValid(word: String) -> Bool {
        MockData.wordBank.contains(word.lowercased())
    }
    
    private func moveToNextRow() {
        currentRowIndex += 1
        currentGuess = ""
    }
    
    func setCellBackgroundColours() {
        var guessedLetterCounts: [Character : Int] = [:]

        currentGuess.enumerated().forEach { index, letter in
            if guessedLetterCounts[letter] != nil {
                guessedLetterCounts[letter]! += 1
            } else {
                guessedLetterCounts[letter] = 1
            }
            
            let backgroundColour = getCellBackgroundColour(index: index, letter: letter)
            guard let value = guessedLetterCounts[letter], value <= answer.filter({ $0 == letter }).count else {
                return
            }
            gridCellModels[gridIndexFromCurrentGuessLetterIndex(index)].backgroundColour = backgroundColour
        }
    }
    
    func setKeyboardKeyBackgroundColours() {
        currentGuess.enumerated().forEach { index, letter in
            guard let letterIndex = letterKeyModels.firstIndex(where: { $0.value.lowercased() == String(letter) }) else { return }
            letterKeyModels[letterIndex].backgroundColour = getLetterKeyBackgroundColour(index: index, letter: letter)
        }
    }
    
    func getLetterKeyBackgroundColour(index: Int, letter: Character) -> Color {
        let answerArray = Array(answer)
        if answerArray[index] == letter {
            return ColourManager.letterInCorrectPosition
        }
        if answerArray.contains(letter) {
            return ColourManager.letterInWrongPosition
        }
        return ColourManager.letterNotInAnswerKeyboard
    }
    
    func getCellBackgroundColour(index: Int, letter: Character) -> Color {
        let answerArray = Array(answer)
        if answerArray[index] == letter {
            return ColourManager.letterInCorrectPosition
        }
        if answerArray.contains(letter) {
            return ColourManager.letterInWrongPosition
        }
        return ColourManager.letterNotInAnswerCell
    }
    
    private func gridIndexFromCurrentGuessLetterIndex(_ letterIndex: Int) -> Int {
        (currentRowIndex * Self.numberOfColumns) + letterIndex
    }
    
}
