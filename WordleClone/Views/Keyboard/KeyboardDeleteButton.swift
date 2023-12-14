//
//  KeyboardDeleteButton.swift
//  WordleClone
//
//  Created by Fiona Wilson on 13/12/2023.
//

import SwiftUI

struct KeyboardDeleteButton: View {
    
    var onPress: () -> Void
    let keyWidth: CGFloat
    
    var body: some View {
        KeyboardButton(onPress: onPress, width: keyWidth) { Image(systemName: "delete.left")}
    }
}

#Preview {
    KeyboardDeleteButton(onPress: {}, keyWidth: 60.0)
}
