//
//  ContentView.swift
//  WordleClone
//
//  Created by Fiona Wilson on 01/12/2023.
//

import SwiftUI

struct GameScreenView: View {
    
    @StateObject private var viewModel = GameScreenViewModel(wordGenerator: WordGenerator())
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Wordle")
                        .font(.title)
                        .foregroundStyle(Color(UIColor.label))
                        .bold()
                    Spacer()
                }
                .padding(.horizontal, 20)
                
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
            .overlay(alignment: .topTrailing) {
                Button {
                    viewModel.resetGrid()
                } label: {
                    Image(systemName: "arrow.circlepath")
                        .foregroundColor(Color(UIColor.label))
                        .padding(20)
                }
            }

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
