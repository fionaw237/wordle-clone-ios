//
//  ContentView.swift
//  WordleClone
//
//  Created by Fiona Wilson on 01/12/2023.
//

import SwiftUI

struct KeyboardDeleteButton: View {
    var onPress: () -> Void
    
    let letterKeyWidth = (UIScreen.main.bounds.width - 77.0) / 10
    
    let keyWidth: CGFloat = ((UIScreen.main.bounds.width - 9 * (UIScreen.main.bounds.width - 77.0) / 10)) / 2
    
    var body: some View {
        Button {
            onPress()
        } label: {
            Image(systemName: "delete.left")
                .frame(width: keyWidth, height: 60)
                .background(.gray)
                .foregroundColor(.white)
                .cornerRadius(4.0)
        }
    }
}

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

struct KeyboardLetterButton: View {
    
    var letterModel: KeyboardLetterKeyModel
    
    let keyWidth: CGFloat = (UIScreen.main.bounds.width - 77.0) / 10
    
    var body: some View {
        Button {
            letterModel.onPress()
        } label: {
            Text(letterModel.value)
                .frame(width: keyWidth, height: 60)
                .background(letterModel.backgroundColour)
                .foregroundColor(.white)
                .cornerRadius(4.0)
        }
        .disabled(letterModel.isDisabled)
    }
}


struct GameScreenView: View {
    
    @StateObject private var viewModel = GameScreenViewModel(wordGenerator: WordGenerator())
    
    var body: some View {
        ZStack {
            VStack {                
                LazyVGrid(columns: viewModel.gridColumns) {
                    ForEach(viewModel.gridCellModels) { cellModel in
                        LetterGridCellView(cellModel: cellModel)
                    }
                }
                .padding(.horizontal, 20)
                .onAppear {
                    viewModel.newGame()
                }
                
                Spacer()
                HStack {
                    ForEach(viewModel.letterKeyModels[0...9]) { letterModel in
                        KeyboardLetterButton(letterModel: letterModel)
                    }
                }
                
                HStack {
                    ForEach(viewModel.letterKeyModels[10...18]) { letterModel in
                        KeyboardLetterButton(letterModel: letterModel)
                    }
                }
                
                HStack {
                    KeyboardEnterButton(onPress: { viewModel.enterKeyPressed() })
                    ForEach(viewModel.letterKeyModels[19...25]) { letterModel in
                        KeyboardLetterButton(letterModel: letterModel)
                    }
                    KeyboardDeleteButton(onPress: { viewModel.deleteKeyPressed() })
                }
                
            }
            .blur(radius: viewModel.showGameCompletedModal ? 5 : 0)
            .padding(.top, 20)

            if viewModel.showGameCompletedModal {
                GameCompletedView(isVisible: $viewModel.showGameCompletedModal)
            }
        }
        .background(Color(UIColor.systemBackground))
        Spacer()
    }
}


#Preview {
    GameScreenView()
}
