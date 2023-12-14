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
        Button {
            onPress()
        } label: {
            Text("ENTER")
                .frame(width: keyWidth, height: 60)
                .background(.gray)
                .foregroundColor(.white)
                .cornerRadius(4.0)
                .font(.footnote)
        }
    }
}

#Preview {
    KeyboardEnterButton(onPress: {})
}
