//
//  KeyboardEnterButton.swift
//  WordleClone
//
//  Created by Fiona Wilson on 13/12/2023.
//

import SwiftUI

struct KeyboardEnterButton: View {
    
    var onPress: () -> Void
    let keyWidth: CGFloat
    
    var body: some View {
        KeyboardButton(onPress: onPress, width: keyWidth) {
            Text("ENTER")
                .font(.footnote)
        }
    }
}

#Preview {
    KeyboardEnterButton(onPress: {}, keyWidth: 60.0)
}
