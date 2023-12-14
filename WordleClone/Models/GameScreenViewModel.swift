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
    
    let gridColumns: [GridItem] = [
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem()
    ]
        
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
    
    @Published var letterKeyModels: [KeyboardLetterKeyModel] = []
    
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
        wordGenerator.wordBank.contains(word.lowercased())
    }
    
    private func moveToNextRow() {
        currentRowIndex += 1
        currentGuess = ""
    }
    
    func setCellBackgroundColours() {
        var greenOrYellowLetterCounts: [Character : Int] = [:]
        var answerLetterCounts: [Character : Int] = [:]
        
        answer.forEach { letter in
            answerLetterCounts[letter] = (answerLetterCounts[letter] ?? 0) + 1
        }
        
        let answerArray = Array(answer)
        var greenIndices: [Int] = []
        
        currentGuess.enumerated().forEach { index, letter in
            if answerArray[index] == letter {
                greenOrYellowLetterCounts[letter] = (greenOrYellowLetterCounts[letter] ?? 0) + 1
                greenIndices.append(index)
            }
        }
                
        for (index, letter) in currentGuess.enumerated() {
            if greenIndices.contains(index) {
                gridCellModels[gridIndexFromCurrentGuessLetterIndex(index)].backgroundColour = ColourManager.letterInCorrectPosition
                continue
            }
            
            let colouredLetterCount = greenOrYellowLetterCounts[letter] ?? 0

            if let answerLetterCount = answerLetterCounts[letter],
               answerLetterCount > colouredLetterCount {
                gridCellModels[gridIndexFromCurrentGuessLetterIndex(index)].backgroundColour = ColourManager.letterInWrongPosition
                greenOrYellowLetterCounts[letter] = (greenOrYellowLetterCounts[letter] ?? 0) + 1
                continue
            } else {
                gridCellModels[gridIndexFromCurrentGuessLetterIndex(index)].backgroundColour = ColourManager.letterNotInAnswerCell
                continue
            }
            
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
