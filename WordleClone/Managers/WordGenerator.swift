//
//  WordGenerator.swift
//  WordleClone
//
//  Created by Fiona Wilson on 05/12/2023.
//

import Foundation

// TODO: Handle errors more thoroughly (error messages etc)
enum WordGeneratorError: Error {
    case FileNotFoundError
    case WordReadError
}

protocol WordGeneratorProtocol {
    var wordBank: Set<String> { get set }
    func generateWord() -> String?
}

struct WordGenerator: WordGeneratorProtocol {
    var wordBank = Set<String>()
    
    func readWordsFromFile() throws -> Set<String>? {
        do {
            guard let file = Bundle.main.url(forResource: "five-letter-words", withExtension: "txt") else {
                throw(WordGeneratorError.FileNotFoundError)
            }
            let wordsFromFile = try String(contentsOf: file, encoding: .utf8)
            let wordsStringArray = wordsFromFile.split(separator: "\n").map { String($0) }
            return Set(wordsStringArray)
        } catch {
            throw(error)
        }
    }
    
    init() {
        do {
            guard let words = try? readWordsFromFile() else {
                throw(WordGeneratorError.WordReadError)
            }
            wordBank = words
        } catch {
            print(error)
        }
    }
    
    func generateWord() -> String? {
        wordBank.randomElement()
    }
}




