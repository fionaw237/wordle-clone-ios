//
//  GameCompletedView.swift
//  WordleClone
//
//  Created by Fiona Wilson on 13/12/2023.
//

import SwiftUI

struct GameCompletedView: View {
    
    @Binding var isVisible: Bool
    var answerData: DictionaryData
    var message: String = "You won!"
    
    var body: some View {
        VStack {
            Text(message)
                .bold()
            Text("Answer is \(answerData.word)")
            Text("Definition")
                .bold()
            Text(answerData.definition)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 40)
        .overlay(alignment: .topTrailing) {
            Button {
                isVisible = false
            } label: {
                CircleCloseButton()
            }
        }
    }
}

#Preview {
    GameCompletedView(isVisible: .constant(true), answerData: DictionaryData(word: "Hello", definition: "A greeting"))
}
