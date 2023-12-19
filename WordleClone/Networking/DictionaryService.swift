//
//  DictionaryService.swift
//  WordleClone
//
//  Created by Fiona Wilson on 14/12/2023.
//

import Foundation

protocol DictionaryServiceProtocol {
    var httpClient: HttpClientProtocol { get set }
    func getDictionaryData(for word: String) async throws -> DictionaryData
}

struct DictionaryService: DictionaryServiceProtocol {
    var httpClient: HttpClientProtocol

    func getDictionaryData(for word: String) async throws -> DictionaryData {
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else {
            return DictionaryData(word: word)
        }
        let data: [WordDataResponse] = try await httpClient.fetchData(from: url)
        let definition = data.first?.meanings.first?.definitions.first?.definition ?? ""
        return DictionaryData(word: word, definition: definition)
    }
}
