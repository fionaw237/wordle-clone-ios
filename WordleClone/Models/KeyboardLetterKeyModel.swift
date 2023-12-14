//
//  KeyboardLetterKeyModel.swift
//  WordleClone
//
//  Created by Fiona Wilson on 14/12/2023.
//

import Foundation
import SwiftUI

struct KeyboardLetterKeyModel: Identifiable {
    var id = UUID()
    var value: String
    var isDisabled: Bool = false
    var onPress: () -> Void
    var backgroundColour: Color = .gray {
        didSet {
            if backgroundColour == ColourManager.letterNotInAnswerKeyboard {
                isDisabled = true
            }
        }
    }
}
