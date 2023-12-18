//
//  KeyboardDeleteButton.swift
//  WordleClone
//
//  Created by Fiona Wilson on 13/12/2023.
//

import SwiftUI

struct KeyboardDeleteButton: View {
    
    var onPress: () -> Void
    var isDisabled: Bool
    let keyWidth: CGFloat
    
    var body: some View {
        KeyboardButton(onPress: onPress, width: keyWidth) { Image(systemName: "delete.left")}
            .disabled(isDisabled)
    }
}

#Preview {
    KeyboardDeleteButton(onPress: {}, isDisabled: false, keyWidth: 60.0)
}
