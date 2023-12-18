//
//  WordleCloneTests.swift
//  WordleCloneTests
//
//  Created by Fiona Wilson on 01/12/2023.
//

import XCTest
import SwiftUI
@testable import WordleClone

private struct MockDictionaryService: DictionaryServiceProtocol {
    var httpClient: HttpClientProtocol
    
    func getDictionaryData(for word: String, completion: @escaping (DictionaryData?) -> Void) {
        
    }

}

final class GameScreenViewModelTests: XCTestCase {
    
    // MARK: Setup
    
    var sut: GameScreenViewModel!

    override func setUpWithError() throws {
        sut = GameScreenViewModel(
            wordGenerator: WordGenerator(),
            dictionaryService: MockDictionaryService(httpClient: MockHttpClient())
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: Helper functions
    
    private func makeSUT(lettersPressed: [String]) {
        sut = GameScreenViewModel(
            wordGenerator: WordGenerator(),
            dictionaryService: MockDictionaryService(httpClient: MockHttpClient())
        )
        sut.newGame()
        lettersPressed.forEach { letter in
            sut.letterKeyPressed(String(letter))
        }
    }
    
    private func makeSUTWithMockAnswer(_ answer: String) {
        sut = GameScreenViewModel(
            wordGenerator: WordGeneratorMock(mockAnswer: answer),
            dictionaryService: MockDictionaryService(httpClient: MockHttpClient())
        )
    }
    
    private func makeGuess(_ guess: String) {
        Array(arrayLiteral: guess).forEach { letter in
            sut.letterKeyPressed(letter)
        }
        sut.enterKeyPressed()
    }
    
    private func makeRepeatedGuess(_ guess: String, noOfTimes: Int) {
        for _ in 1...noOfTimes { makeGuess(guess) }
    }
    
    // MARK: Tests
    
    func test_newGame_callsWordGenerator_setsAnswerProperty() {
        let mockAnswer = "hello"
        makeSUTWithMockAnswer(mockAnswer)
        sut.newGame()
        XCTAssertEqual(sut.answer, mockAnswer)
    }
    
    func test_generateAnswer_generateAnswerFromWordBank() throws {
        sut = GameScreenViewModel(
            wordGenerator: WordGenerator(),
            dictionaryService: MockDictionaryService(httpClient: MockHttpClient())
        )
        let answer = try XCTUnwrap(sut.wordGenerator.generateWord())
        XCTAssertTrue(sut.wordGenerator.wordBank.contains(answer), "Test failed: word bank does not include \(answer)")
    }
    
    func test_setup_setsGeneratedAnswer() {
        sut.newGame()
        XCTAssertTrue(!sut.answer.isEmpty)
    }
    
    func test_letterKeyPressed_atStartOfGame_updatesCurrentGuessAndGridModels() {
        sut.letterKeyPressed("A")
        XCTAssertEqual(sut.currentGuess, "a")
        XCTAssertEqual(sut.gridCellModels[0].letter, "A")
        XCTAssertEqual(sut.gridCellModels[0].borderColour, ColourManager.highlightedLetter)
        XCTAssertEqual(sut.gridCellModels[1].borderColour, ColourManager.unenteredLetter)
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
        XCTAssertEqual(sut.gridCellModels[2].borderColour, ColourManager.unenteredLetter)
    }
    
    func test_deletePressed_WhenRowIsFull_removesLastLetter() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "E"])
        sut.deleteKeyPressed()
        XCTAssertEqual(sut.gridCellModels[4].letter, "")
        XCTAssertEqual(sut.currentGuess, "appl")
    }
    
    func test_enterKeyPressed_forValidWord_movesToNextRowAndResetCurrentGuess() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeGuess("apple")
        XCTAssertEqual(sut.currentRowIndex, 1)
        XCTAssertEqual(sut.currentGuess, "")
    }
    
    func test_enterKeyPressed_forValidWord_cellsHaveClearBorder() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeGuess("apple")
        XCTAssertEqual(sut.gridCellModels[0].borderColour, Color.clear)
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
        makeSUTWithMockAnswer("apple")
        sut.newGame()
        makeGuess("paint")
        XCTAssertEqual(sut.gridCellModels[2].backgroundColour, ColourManager.letterNotInAnswerCell)
    }
    
    func test_setCellBackgroundColours_letterFromGuessInWrongPosition_hasYellowBackgroundColour() {
        makeSUTWithMockAnswer("apple")
        sut.newGame()
        makeGuess("paint")
        XCTAssertEqual(sut.gridCellModels[0].backgroundColour, ColourManager.letterInWrongPosition)
    }
    
    func test_setCellBackgroundColours_letterFromGuessInCorrectPosition_hasGreenBackgroundColour() {
        makeSUTWithMockAnswer("thing")
        sut.newGame()
        makeGuess("paint")
        XCTAssertEqual(sut.gridCellModels[2].backgroundColour, ColourManager.letterInCorrectPosition)
    }
    
    func test_setCellBackgroundColours_secondGuessWithCorrectLetter_hasGreenBackgroundColour() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeGuess("apple")
        makeGuess("fancy")
        XCTAssertEqual(sut.gridCellModels[6].backgroundColour, ColourManager.letterInCorrectPosition)
    }
    
    func test_setCellBackgroundColours_secondGuessWithCorrectWord_hasGreenBackgroundColours() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeGuess("apple")
        makeGuess("paint")
        (5...9).forEach { index in
            XCTAssertEqual(sut.gridCellModels[index].backgroundColour, ColourManager.letterInCorrectPosition)
        }
    }
    
    func test_setCellBackgroundColours_ifAnswerHasOneInstanceOfLetterAndGuessHasTwoInWrongPosition_onlyShouldGoYellow() {
        makeSUTWithMockAnswer("glass")
        sut.newGame()
        makeGuess("foggy")
        XCTAssertEqual(sut.gridCellModels[2].backgroundColour, ColourManager.letterInWrongPosition)
        XCTAssertEqual(sut.gridCellModels[3].backgroundColour, ColourManager.letterNotInAnswerCell)
    }
    
    func test_setCellBackgroundColours_ifAnswerHasTwoInstancesOfLetterOneInIncorrectPosition_OneShouldGoYellowAndTheOtherGreen() {
        makeSUTWithMockAnswer("pipes")
        sut.newGame()
        makeGuess("apple")
        XCTAssertEqual(sut.gridCellModels[1].backgroundColour, ColourManager.letterInWrongPosition)
        XCTAssertEqual(sut.gridCellModels[2].backgroundColour, ColourManager.letterInCorrectPosition)
    }
    
    func test_setCellBackgroundColours_ifAnswerHasOneInstanceOfLetterAndGuessHasThreeWithFirstTwoInWrongPosition_onlyThirdShouldGoGreen() {
        makeSUTWithMockAnswer("rainy")
        sut.newGame()
        makeGuess("nanny")
        XCTAssertEqual(sut.gridCellModels[0].backgroundColour, ColourManager.letterNotInAnswerCell)
        XCTAssertEqual(sut.gridCellModels[2].backgroundColour, ColourManager.letterNotInAnswerCell)
        XCTAssertEqual(sut.gridCellModels[3].backgroundColour, ColourManager.letterInCorrectPosition)
    }
    
    func test_showGameCompletedModal_setToTrueWhenGameIsWon() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeGuess("paint")
        XCTAssertTrue(sut.showGameCompletedModal)
    }
    
    func test_showGameCompletedModel_remainsFalseWhenGameNotFinished() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeGuess("apple")
        XCTAssertFalse(sut.showGameCompletedModal)
    }
    
    func test_showGameCompletedModal_setToTrueWhenGameOver() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeRepeatedGuess("teeth", noOfTimes: 6)
        XCTAssertTrue(sut.showGameCompletedModal)
    }
    
    func test_newGame_resetsGame() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeRepeatedGuess("teeth", noOfTimes: 6)
        sut.resetGrid()
        XCTAssertEqual(sut.currentGuess, "")
        XCTAssertEqual(sut.currentRowIndex, 0)
        XCTAssertTrue(sut.gridCellModels.allSatisfy { gridModel in gridModel.letter == "" })
        XCTAssertTrue(sut.letterKeyModels.allSatisfy { model in model.backgroundColour == .gray })
    }
    
    func test_initialiseKeyboard_setsKeyboardLetters() {
        let expectedKeyboardLetters = "QWERTYUIOPASDFGHJKLZXCVBNM".map { String($0) }
        sut.newGame()
        XCTAssertEqual(sut.letterKeyModels.map { $0.value }, expectedKeyboardLetters)
    }
    
    func test_setLetterBackgroundColour_setsLetterToGreenWhenGuessedLetterInCorrectPosition() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeGuess("handy")
        XCTAssertEqual(sut.letterKeyModels[10].backgroundColour, ColourManager.letterInCorrectPosition)
    }
    
    func test_setLetterBackgroundColour_setsLetterToYellowWhenGuessedLetterIsNotInCorrectPosition() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeGuess("handy")
        XCTAssertEqual(sut.letterKeyModels[24].backgroundColour, ColourManager.letterInWrongPosition)
    }
    
    func test_setLetterBackgroundColour_setsLetterToDarkGrayWhenGuessedLetterIsNotInAnswer() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeGuess("handy")
        XCTAssertEqual(sut.letterKeyModels[15].backgroundColour, ColourManager.letterNotInAnswerKeyboard)
        XCTAssertEqual(sut.letterKeyModels[12].backgroundColour, ColourManager.letterNotInAnswerKeyboard)
        XCTAssertEqual(sut.letterKeyModels[5].backgroundColour, ColourManager.letterNotInAnswerKeyboard)
    }
    
    func test_setLetterBackgroundColour_KeyDisabledWhenLetterNotInAnswer() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeGuess("handy")
        XCTAssertTrue(sut.letterKeyModels[15].isDisabled)
        XCTAssertTrue(sut.letterKeyModels[12].isDisabled)
        XCTAssertTrue(sut.letterKeyModels[5].isDisabled)
    }
    
    func test_setLetterBackgroundColour_KeyEnabledWhenLetterInAnswer() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeGuess("handy")
        XCTAssertFalse(sut.letterKeyModels[10].isDisabled)
        XCTAssertFalse(sut.letterKeyModels[24].isDisabled)
    }
    
    func test_whenGameEnds_disableAllKeys() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeRepeatedGuess("teeth", noOfTimes: 6)
        XCTAssertTrue(sut.letterKeyModels.allSatisfy { $0.isDisabled })
        XCTAssertTrue(sut.keyboardActionButtonsDisabled)
    }
    
    func test_newGame_enableAllKeys() {
        makeSUTWithMockAnswer("paint")
        sut.newGame()
        makeRepeatedGuess("teeth", noOfTimes: 6)
        sut.resetGrid()
        XCTAssertTrue(sut.letterKeyModels.allSatisfy { !$0.isDisabled })
        XCTAssertFalse(sut.keyboardActionButtonsDisabled)
    }
    
    
}
