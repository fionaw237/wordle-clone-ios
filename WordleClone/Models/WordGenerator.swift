//
//  WordGenerator.swift
//  WordleClone
//
//  Created by Fiona Wilson on 05/12/2023.
//

import Foundation

protocol WordGeneratorProtocol {
    func generateWord() -> String?
}

class WordGenerator: WordGeneratorProtocol {
    func generateWord() -> String? {
        MockData.wordBank.randomElement()
    }
}
