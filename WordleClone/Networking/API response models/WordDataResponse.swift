//
//  WordDataResponse.swift
//  WordleClone
//
//  Created by Fiona Wilson on 15/12/2023.
//

import Foundation

struct WordDataResponse: Decodable {
    let word: String
    let meanings: [WordMeaning]
}
