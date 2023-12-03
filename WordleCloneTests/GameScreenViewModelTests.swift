//
//  WordleCloneTests.swift
//  WordleCloneTests
//
//  Created by Fiona Wilson on 01/12/2023.
//

import XCTest
@testable import WordleClone

final class GameScreenViewModelTests: XCTestCase {
    
    // MARK: Setup
    
    var sut: GameScreenViewModel!

    override func setUpWithError() throws {
        sut = GameScreenViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: Helper functions
    
    private func makeSUT(lettersPressed: [String]) {
        lettersPressed.forEach { letter in
            sut.letterKeyPressed(String(letter))
        }
    }
    
    // MARK: Tests
    
    func test_generateAnswer_generateAnswerFromWordBank() throws {
        let answer = try XCTUnwrap(sut.generateAnswer())
        XCTAssertTrue(MockData.wordBank.contains(answer), "Test failed: word bank does not include \(answer)")
    }
    
    func test_setup_setsGeneratedAnswer() {
        sut.newGame()
        XCTAssertTrue(!sut.answer.isEmpty)
    }
    
    func test_letterKeyPressed_atStartOfGame_updatesLettersEnteredInRowCountAndGridModel() {
        sut.letterKeyPressed("A")
        XCTAssertEqual(sut.lettersEnteredInRow, 1)
        XCTAssertEqual(sut.gridCellModels.first?.letter, "A")
    }
    
    func test_letterKeyPressed_whenRowIsFull_doesNotUpdateLettersEnteredInRowOrRowIndex() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "E", "S"])
        XCTAssertEqual(sut.lettersEnteredInRow, 5)
        XCTAssertEqual(sut.currentRowIndex, 0)
    }
    
    func test_letterKeyPressed_whenRowIsFull_doesNotUpdateNextRow() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "E", "S"])
        XCTAssertEqual(sut.gridCellModels[5].letter, "")
    }
    
    func test_deletePressed_whenRowIsEmpty_doesNotDecreaseColumnIndex() {
        sut.deleteKeyPressed()
        XCTAssertEqual(sut.lettersEnteredInRow, 0)
    }
    
    func test_deletePressed_removesLastEnteredLetter() {
        makeSUT(lettersPressed: ["A", "P", "P"])
        sut.deleteKeyPressed()
        XCTAssertEqual(sut.gridCellModels[0].letter, "A")
        XCTAssertEqual(sut.gridCellModels[1].letter, "P")
        XCTAssertEqual(sut.gridCellModels[2].letter, "")
    }
    
    func test_deletePressed_WhenRowIsFull_removesLastLetter() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "E"])
        sut.deleteKeyPressed()
        XCTAssertEqual(sut.gridCellModels[4].letter, "")
        XCTAssertEqual(sut.lettersEnteredInRow, 4)
    }
    
    func test_enterKeyPressed_forValidWord_movesToNextRow() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "E"])
        sut.enterKeyPressed()
        XCTAssertEqual(sut.currentRowIndex, 1)
        XCTAssertEqual(sut.lettersEnteredInRow, 0)
    }
    
    func test_enterKeyPressed_whenRowIsNotFull_doesNothing() {
        makeSUT(lettersPressed: ["A", "P", "P", "L"])
        sut.enterKeyPressed()
        XCTAssertEqual(sut.currentRowIndex, 0)
        XCTAssertEqual(sut.lettersEnteredInRow, 4)
    }

    func test_enterKeyPressed_forValidWord_thenTypingMoreLettersUpdatesGridModel() {
        makeSUT(lettersPressed: ["A", "P", "P", "L", "E"])
        sut.enterKeyPressed()
        sut.letterKeyPressed("Y")
        XCTAssertEqual(sut.gridCellModels[5].letter, "Y")
    }
    
}
