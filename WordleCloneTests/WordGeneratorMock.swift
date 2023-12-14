//
//  WordGeneratorMock.swift
//  WordleCloneTests
//
//  Created by Fiona Wilson on 14/12/2023.
//

import Foundation
@testable import WordleClone

struct WordGeneratorMock: WordGeneratorProtocol {
    
    var wordBank = MockData.wordBank
    
    var mockAnswer = ""
    
    init(mockAnswer: String = "") {
        self.mockAnswer = mockAnswer
    }
    
    func generateWord() -> String? {
        return mockAnswer
    }
}
