//
//  DictionaryService.swift
//  WordleClone
//
//  Created by Fiona Wilson on 14/12/2023.
//

import Foundation

protocol DictionaryServiceProtocol {
    var httpClient: HttpClientProtocol { get set }
    func getDictionaryData(for word: String, completion: @escaping (DictionaryData?) -> Void)
}

enum DataFetchError: String, Error {
    case urlCreation = "Could not create URL."
    case decode = "Error decoding JSON."
    case server = "The server responded with an error."
}

struct DictionaryService: DictionaryServiceProtocol {
    var httpClient: HttpClientProtocol
    
    func getDictionaryData(for word: String, completion: @escaping (DictionaryData?) -> Void) {
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else {
//            throw DataFetchError.urlCreation
            return
        }
        
        httpClient.fetchData(from: url) { (data: [WordDataResponse]) in
            let definition = data.first?.meanings.first?.definitions.first?.definition
            guard let definition else {
                completion(nil)
                return
            }
            completion(DictionaryData(word: word, definition: definition))
        }

    }
}
