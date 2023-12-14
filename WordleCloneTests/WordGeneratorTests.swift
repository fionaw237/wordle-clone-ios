//
//  WordGeneratorTests.swift
//  WordleCloneTests
//
//  Created by Fiona Wilson on 14/12/2023.
//

import XCTest
@testable import WordleClone

final class WordGeneratorTests: XCTestCase {
    
    // MARK: Setup
    
    var sut: WordGenerator!

    override func setUpWithError() throws {
        sut = WordGenerator()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: Tests

    func test_init_populatesWordBankWithAllWords() {
        XCTAssertEqual(sut.wordBank.count, 5757)
    }
    
    func test_init_allWordsInWordBankHaveCorrectLength() {
        XCTAssertTrue(sut.wordBank.allSatisfy { $0.count == 5 })
    }
    
    func test_generateWord_generatesWordFromWordBank() throws {
        let randomWord = try XCTUnwrap(sut.generateWord())
        XCTAssertTrue(sut.wordBank.contains(randomWord))
    }

    // TODO: Add tests for errors
}
