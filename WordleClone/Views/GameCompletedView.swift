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
                .font(.title)
                .bold()
                .padding(.bottom, 50)
            Spacer()
            VStack {
                HStack {
                    Text("Answer is")
                    Text("\(answerData.word)")
                        .font(.title2)
                        .bold()
                }
                .padding()
                Text("Definition")
                    .bold()
                Text(answerData.definition)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .border(ColourManager.letterInCorrectPosition, width: 2)
            .cornerRadius(4.0)
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .padding()
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
