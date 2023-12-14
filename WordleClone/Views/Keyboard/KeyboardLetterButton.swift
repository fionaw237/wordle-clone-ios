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
        Button {
            letterModel.onPress()
        } label: {
            Text(letterModel.value)
                .frame(width: keyWidth, height: 60)
                .background(letterModel.backgroundColour)
                .foregroundColor(.white)
                .cornerRadius(4.0)
        }
        .disabled(letterModel.isDisabled)
    }
}

#Preview {
    KeyboardLetterButton(letterModel: KeyboardLetterKeyModel(value: "A", onPress: {}))
}
