//
//  KeyboardEnterButton.swift
//  WordleClone
//
//  Created by Fiona Wilson on 13/12/2023.
//

import SwiftUI

struct KeyboardEnterButton: View {
    
    var onPress: () -> Void
    var isDisabled: Bool
    let keyWidth: CGFloat
    
    var body: some View {
        KeyboardButton(onPress: onPress, width: keyWidth) {
            Text("ENTER")
                .font(.footnote)
        }
        .disabled(isDisabled)
    }
}

#Preview {
    KeyboardEnterButton(onPress: {}, isDisabled: false, keyWidth: 60.0)
}
