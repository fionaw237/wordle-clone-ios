//
//  KeyboardLetterButton.swift
//  WordleClone
//
//  Created by Fiona Wilson on 13/12/2023.
//

import SwiftUI

struct KeyboardLetterButton: View {
    
    var letterModel: KeyboardLetterKeyModel
    
    let keyWidth: CGFloat = (UIScreen.main.bounds.width - 77.0) / 10
    
    var body: some View {
        KeyboardButton(
            onPress: letterModel.onPress,
            width: keyWidth,
            backgroundColour: letterModel.backgroundColour,
            isDisabled: letterModel.isDisabled
        ) {
            Text(letterModel.value)
        }
    }
}

#Preview {
    KeyboardLetterButton(letterModel: KeyboardLetterKeyModel(value: "A", onPress: {}))
}
