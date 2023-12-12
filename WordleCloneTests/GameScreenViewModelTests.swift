//
//  WordleCloneTests.swift
//  WordleCloneTests
//
//  Created by Fiona Wilson on 01/12/2023.
//

import XCTest
import SwiftUI
@testable import WordleClone

private class WordGeneratorMock: WordGeneratorProtocol {
    
    var mockAnswer = ""
    
    init(mockAnswer: String = "") {
        self.mockAnswer = mockAnswer
    }
    
    func generateWord() -> String? {
        return mockAnswer
    }
}

final class GameScreenViewModelTests: XCTestCase {
    
    // MARK: Setup
    
    var sut: GameScreenViewModel!

    override func setUpWithError() throws {
        sut = GameScreenViewModel(wordGenerator: WordGenerator())
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: Helper functions
    
    private func makeSUT(lettersPressed: [String]) {
        sut = GameScreenViewModel(wordGenerator: WordGenerator())
        sut.newGame()
        lettersPressed.forEach { letter in
            sut.letterKeyPressed(String(letter))
        }
    }
    
    private func makeGuess(_ guess: String) {
        Array(arrayLiteral: guess).forEach { letter in
            sut.letterKeyPressed(letter)
        }
        sut.enterKeyPressed()
    }
    
    // MARK: Tests
    
    func test_newGame_callsWordGenerator_setsAnswerProperty() {
        let mockAnswer = "hello"
        sut = GameScreenViewModel(wordGenerator: WordGeneratorMock(mockAnswer: mockAnswer))
        sut.newGame()
        XCTAssertEqual(sut.answer, mockAnswer)
    }
    
    func test_generateAnswer_generateAnswerFromWordBank() throws {
        sut = GameScreenViewModel(wordGenerator: WordGenerator())
        let answer = try XCTUnwrap(sut.wordGenerator.generateWord())
        XCTAssertTrue(MockData.wordBank.contains(answer), "Test failed: word bank does not include \(answer)")
    }
    
    func test_setup_setsGeneratedAnswer() {
        sut.newGame()
        XCTAssertTrue(!sut.answer.isEmpty)
    }
    
    func test_letterKeyPressed_atStartOfGame_updatesCurrentGuessAndGridModels() {
        sut.letterKeyPressed("A")
        XCTAssertEqual(sut.currentGuess, "a")
        XCTAssertEqual(sut.gridCellModels[0].letter, "A")
    }
    
    func test_letterKeyPressed_whenRowIsFull_doesNotUpdateCurrentGuessOrRowIndex() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "E", "S"])
        XCTAssertEqual(sut.currentGuess, "apple")
        XCTAssertEqual(sut.currentRowIndex, 0)
    }
    
    func test_letterKeyPressed_whenRowIsFull_doesNotUpdateNextRow() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "E", "S"])
        XCTAssertEqual(sut.gridCellModels[5].letter, "")
    }
    
    func test_deletePressed_whenRowIsEmpty_doesNotChangeCurrentGuess() {
        sut.deleteKeyPressed()
        XCTAssertEqual(sut.currentGuess, "")
    }
    
    func test_deletePressed_removesLastEnteredLetter() {
        makeSUT(lettersPressed: ["A", "P", "P"])
        sut.deleteKeyPressed()
        XCTAssertEqual(sut.gridCellModels[0].letter, "A")
        XCTAssertEqual(sut.gridCellModels[1].letter, "P")
        XCTAssertEqual(sut.gridCellModels[2].letter, "")
        XCTAssertEqual(sut.currentGuess, "ap")
    }
    
    func test_deletePressed_WhenRowIsFull_removesLastLetter() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "E"])
        sut.deleteKeyPressed()
        XCTAssertEqual(sut.gridCellModels[4].letter, "")
        XCTAssertEqual(sut.currentGuess, "appl")
    }
    
    func test_enterKeyPressed_forValidWord_movesToNextRowAndResetCurrentGuess() {
        let mockAnswer = "paint"
        sut = GameScreenViewModel(wordGenerator: WordGeneratorMock(mockAnswer: mockAnswer))
        sut.newGame()
        makeGuess("apple")
        XCTAssertEqual(sut.currentRowIndex, 1)
        XCTAssertEqual(sut.currentGuess, "")
    }
    
    func test_enterKeyPressed_forValidWord_resetsCurrentGuess() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "E"])
        sut.enterKeyPressed()
    }
    
    func test_enterKeyPressed_whenRowIsNotFull_doesNothing() {
        makeSUT(lettersPressed: ["A", "P", "P", "L"])
        sut.enterKeyPressed()
        XCTAssertEqual(sut.currentRowIndex, 0)
        XCTAssertEqual(sut.currentGuess, "appl")
    }

    func test_enterKeyPressed_forValidWord_thenTypingMoreLettersUpdatesGridModel() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "E"])
        sut.enterKeyPressed()
        sut.letterKeyPressed("Y")
        XCTAssertEqual(sut.gridCellModels[5].letter, "Y")
        XCTAssertEqual(sut.currentGuess, "y")
    }
    
    func test_enterKeyPressed_forInvalidWord_doesNotProceesToNextRow() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "X"])
        sut.enterKeyPressed()
        XCTAssertEqual(sut.currentRowIndex, 0)
        XCTAssertEqual(sut.currentGuess, "applx")
    }
    
    func test_setCellBackgroundColours_letterFromGuessNotInAnswer_hasPlainBackgroundColour() {
        let mockAnswer = "apple"
        sut = GameScreenViewModel(wordGenerator: WordGeneratorMock(mockAnswer: mockAnswer))
        sut.newGame()
        makeGuess("paint")
        XCTAssertEqual(sut.gridCellModels[2].backgroundColour, ColourManager.letterNotInAnswer)
    }
    
    func test_setCellBackgroundColours_letterFromGuessInWrongPosition_hasYellowBackgroundColour() {
        let mockAnswer = "apple"
        sut = GameScreenViewModel(wordGenerator: WordGeneratorMock(mockAnswer: mockAnswer))
        sut.newGame()
        makeGuess("paint")
        XCTAssertEqual(sut.gridCellModels[0].backgroundColour, ColourManager.letterInWrongPosition)
    }
    
    func test_setCellBackgroundColours_letterFromGuessInCorrectPosition_hasGreenBackgroundColour() {
        let mockAnswer = "thing"
        sut = GameScreenViewModel(wordGenerator: WordGeneratorMock(mockAnswer: mockAnswer))
        sut.newGame()
        makeGuess("paint")
        XCTAssertEqual(sut.gridCellModels[2].backgroundColour, ColourManager.letterInCorrectPosition)
    }
    
    func test_setCellBackgroundColours_secondGuessWithCorrectLetter_hasGreenBackgroundColour() {
        let mockAnswer = "paint"
        sut = GameScreenViewModel(wordGenerator: WordGeneratorMock(mockAnswer: mockAnswer))
        sut.newGame()
        makeGuess("apple")
        makeGuess("fancy")
        XCTAssertEqual(sut.gridCellModels[6].backgroundColour, ColourManager.letterInCorrectPosition)
    }
    
    func test_setCellBackgroundColours_secondGuessWithCorrectWord_hasGreenBackgroundColours() {
        let mockAnswer = "paint"
        sut = GameScreenViewModel(wordGenerator: WordGeneratorMock(mockAnswer: mockAnswer))
        sut.newGame()
        makeGuess("apple")
        makeGuess("paint")
        (5...9).forEach { index in
            XCTAssertEqual(sut.gridCellModels[index].backgroundColour, ColourManager.letterInCorrectPosition)
        }
    }
    
    func test_showGameCompletedModal_setToTrueWhenGameIsWon() {
        let mockAnswer = "paint"
        sut = GameScreenViewModel(wordGenerator: WordGeneratorMock(mockAnswer: mockAnswer))
        sut.newGame()
        makeGuess("paint")
        XCTAssertTrue(sut.showGameCompletedModal)
    }
    
    func test_showGameCompletedModel_remainsFalseWhenGameNotFinished() {
        let mockAnswer = "paint"
        sut = GameScreenViewModel(wordGenerator: WordGeneratorMock(mockAnswer: mockAnswer))
        sut.newGame()
        makeGuess("apple")
        XCTAssertFalse(sut.showGameCompletedModal)
    }
    
    func test_showGameCompletedModal_setToTrueWhenGameOver() {
        let mockAnswer = "paint"
        sut = GameScreenViewModel(wordGenerator: WordGeneratorMock(mockAnswer: mockAnswer))
        sut.newGame()
        makeGuess("teeth")
        makeGuess("teeth")
        makeGuess("teeth")
        makeGuess("teeth")
        makeGuess("teeth")
        makeGuess("teeth")
        XCTAssertTrue(sut.showGameCompletedModal)
    }
    
    
}
