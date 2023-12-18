//
//  ColourManager.swift
//  WordleClone
//
//  Created by Fiona Wilson on 10/12/2023.
//

import Foundation
import SwiftUI

struct ColourManager {
    static let highlightedLetter = Color.white
    static let unenteredLetter = Color.gray
    static let incompleteCell = Color(UIColor.systemBackground)
    static let letterNotInAnswerCell = Color(.darkGray)
    static let letterInWrongPosition = Color.yellow
    static let letterInCorrectPosition = Color.green
    static let letterNotInAnswerKeyboard = Color(.darkGray)
}
