//
//  KeyboardView.swift
//  WordleClone
//
//  Created by Fiona Wilson on 14/12/2023.
//

import SwiftUI

struct KeyboardView: View {
    
    static let letterKeyWidth = (UIScreen.main.bounds.width - 77.0) / 10
    static let actionButtonWidth = (UIScreen.main.bounds.width - 9 * Self.letterKeyWidth / 10) / 2
    
    var letterKeyModels: [KeyboardLetterKeyModel]
    var onEnterPress: () -> Void
    var onDeletePress: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                ForEach(letterKeyModels[0...9]) { letterModel in
                    KeyboardLetterButton(letterModel: letterModel, keyWidth: Self.letterKeyWidth)
                }
            }
            
            HStack {
                ForEach(letterKeyModels[10...18]) { letterModel in
                    KeyboardLetterButton(letterModel: letterModel, keyWidth: Self.letterKeyWidth)
                }
            }
            
            HStack {
                KeyboardEnterButton(onPress: onEnterPress)
                ForEach(letterKeyModels[19...25]) { letterModel in
                    KeyboardLetterButton(letterModel: letterModel, keyWidth: Self.letterKeyWidth)
                }
                KeyboardDeleteButton(onPress: onDeletePress)
            }
        }
    }
}
