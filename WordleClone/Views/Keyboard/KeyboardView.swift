//
//  KeyboardView.swift
//  WordleClone
//
//  Created by Fiona Wilson on 14/12/2023.
//

import SwiftUI

struct KeyboardView: View {
    
    var letterKeyModels: [KeyboardLetterKeyModel]
    var onEnterPress: () -> Void
    var onDeletePress: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                ForEach(letterKeyModels[0...9]) { letterModel in
                    KeyboardLetterButton(letterModel: letterModel)
                }
            }
            
            HStack {
                ForEach(letterKeyModels[10...18]) { letterModel in
                    KeyboardLetterButton(letterModel: letterModel)
                }
            }
            
            HStack {
                KeyboardEnterButton(onPress: onEnterPress)
                ForEach(letterKeyModels[19...25]) { letterModel in
                    KeyboardLetterButton(letterModel: letterModel)
                }
                KeyboardDeleteButton(onPress: onDeletePress)
            }
        }
    }
}
