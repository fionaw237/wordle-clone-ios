//
//  GameScreenViewModel.swift
//  WordleClone
//
//  Created by Fiona Wilson on 01/12/2023.
//

import Foundation
import SwiftUI

enum GameCompletedMessage: String {
    case won = "You won!"
    case lost = "Better luck next time!"
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
        
    let wordGenerator: WordGeneratorProtocol
    let dictionaryService: DictionaryServiceProtocol
    
    init(wordGenerator: WordGeneratorProtocol, dictionaryService: DictionaryServiceProtocol) {
        self.wordGenerator = wordGenerator
        self.dictionaryService = dictionaryService
        initialiseKeyboard()
    }
    
    private func initialiseKeyboard() {
        let letters = "QWERTYUIOPASDFGHJKLZXCVBNM"
        letterKeyModels = letters.map { letter in
            let stringValue = String(letter)
            return KeyboardLetterKeyModel(value: stringValue, onPress: { self.letterKeyPressed(stringValue) })
        }
        keyboardActionButtonsDisabled = false
    }
    
    var answer: String = ""
    var answerDictionaryData = DictionaryData(word: "")
    var currentGuess = ""
    var currentRowIndex = 0
    var currentLetterIndex: Int { (currentRowIndex * Self.numberOfColumns) + currentGuess.count }
    
    var isRowFull: Bool {
        currentGuess.count == 5
    }
    
    var isGameWon: Bool {
        currentGuess == answer
    }
    
    var isGameFinished: Bool {
        isGameWon || (currentRowIndex == 5)
    }
    
    var gameCompletedMessage: GameCompletedMessage = .won
    
    @Published var letterKeyModels: [KeyboardLetterKeyModel] = []
    
    @Published var keyboardActionButtonsDisabled: Bool = false
    
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
        Task {
            answerDictionaryData = try await dictionaryService.getDictionaryData(for: generatedAnswer)
        }
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
            gridCellModels[currentLetterIndex] = LetterGridCellModel(
                letter: letter,
                borderColour: ColourManager.highlightedLetter
            )
            currentGuess += letter.lowercased()
        }
    }
    
    func deleteKeyPressed() {
        guard currentGuess.isNotEmpty else { return }    
        currentGuess.removeLast()
        gridCellModels[currentLetterIndex].letter = ""
        gridCellModels[currentLetterIndex].borderColour = ColourManager.unenteredLetter
    }
    
    func enterKeyPressed() {
        if isRowFull && isValid(word: currentGuess) {
            setCellBackgroundColours()
            setKeyboardKeyBackgroundColours()
            if isGameFinished {
                showGameCompletedModal = true
                gameCompletedMessage = isGameWon ? .won : .lost
                disableKeyboard()
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
    
    private func disableKeyboard() {
        (0..<letterKeyModels.count).forEach { letterKeyModels[$0].isDisabled = true }
        keyboardActionButtonsDisabled = true
    }
    
    func setCellBackgroundColours() {
        var greenOrYellowLetterCounts: [Character : Int] = [:]
        var answerLetterCounts: [Character : Int] = [:]
        
        answer.forEach { letter in
            answerLetterCounts[letter] = (answerLetterCounts[letter] ?? 0) + 1
        }
        
        currentGuess.enumerated().forEach { index, letter in
            if Array(answer)[index] == letter {
                greenOrYellowLetterCounts[letter] = (greenOrYellowLetterCounts[letter] ?? 0) + 1
            }
        }
                
        for (index, letter) in currentGuess.enumerated() {
            gridCellModels[gridIndexFromCurrentGuessLetterIndex(index)].borderColour = .clear
            
            let colouredLetterCount = greenOrYellowLetterCounts[letter] ?? 0
            
            let newLetterState = getLetterState(for: index, letter: letter, answerLetterCount: answerLetterCounts[letter] ?? 0, colouredLetterCount: colouredLetterCount)
            gridCellModels[gridIndexFromCurrentGuessLetterIndex(index)].letterState = newLetterState
            
            if newLetterState == .inWrongPosition {
                greenOrYellowLetterCounts[letter] = (greenOrYellowLetterCounts[letter] ?? 0) + 1
            }
        }
    }
    
    func setKeyboardKeyBackgroundColours() {
        currentGuess.enumerated().forEach { index, letter in
            guard let letterIndex = letterKeyModels.firstIndex(where: { $0.value.lowercased() == String(letter) }) else { return }
            letterKeyModels[letterIndex].backgroundColour = getLetterKeyBackgroundColour(
                index: index,
                letter: letter,
                currentColour: letterKeyModels[letterIndex].backgroundColour
            )
        }
    }
    
    func getLetterState(for index: Int, letter: Character, answerLetterCount: Int, colouredLetterCount: Int) -> LetterState {
        if Array(answer)[index] == letter {
            return .inWord
        }
        if answerLetterCount > colouredLetterCount {
            return .inWrongPosition
        } else {
            return .notInWord
        }
    }
    
    func getLetterKeyBackgroundColour(index: Int, letter: Character, currentColour: Color) -> Color {
        let answerArray = Array(answer)
        let correctPosition = (answerArray[index] == letter) || (currentColour == ColourManager.letterInCorrectPosition)
        if correctPosition {
            return ColourManager.letterInCorrectPosition
        }
        if answerArray.contains(letter) {
            return ColourManager.letterInWrongPosition
        }
        return ColourManager.letterNotInAnswerKeyboard
    }
    
    private func gridIndexFromCurrentGuessLetterIndex(_ letterIndex: Int) -> Int {
        (currentRowIndex * Self.numberOfColumns) + letterIndex
    }
    
}
