//
//  DictionaryData.swift
//  WordleClone
//
//  Created by Fiona Wilson on 15/12/2023.
//

import Foundation

struct DictionaryData: Decodable {
    var word: String
    var definition: String = ""
}
