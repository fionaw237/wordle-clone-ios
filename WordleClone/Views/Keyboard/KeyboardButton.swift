//
//  KeyboardButton.swift
//  WordleClone
//
//  Created by Fiona Wilson on 14/12/2023.
//

import SwiftUI

struct KeyboardButton<ChildView: View>: View {
    
    var onPress: () -> Void
    var width: CGFloat
    var backgroundColour: Color = .gray
    var isDisabled = false
    
    @ViewBuilder let childView: ChildView
    
    var body: some View {
        Button {
            onPress()
        } label: {
            childView
                .frame(width: width, height: 60)
                .background(backgroundColour)
                .foregroundColor(.white)
                .cornerRadius(4.0)
        }
        .disabled(isDisabled)
    }
}
