//
//  KeyboardEnterButton.swift
//  WordleClone
//
//  Created by Fiona Wilson on 13/12/2023.
//

import SwiftUI

struct KeyboardEnterButton: View {
    
    var onPress: () -> Void
    
    let letterKeyWidth = (UIScreen.main.bounds.width - 77.0) / 10
    
    let keyWidth: CGFloat = ((UIScreen.main.bounds.width - 9 * (UIScreen.main.bounds.width - 77.0) / 10)) / 2
    
    var body: some View {
        KeyboardButton(onPress: onPress, width: keyWidth) {
            Text("ENTER")
                .font(.footnote)
        }
    }
}

#Preview {
    KeyboardEnterButton(onPress: {})
}
