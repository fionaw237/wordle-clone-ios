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
                
                KeyboardView(
                    letterKeyModels: viewModel.letterKeyModels,
                    onEnterPress: viewModel.enterKeyPressed,
                    onDeletePress: viewModel.deleteKeyPressed
                )
                
            }
            .blur(radius: viewModel.showGameCompletedModal ? 5 : 0)
            .padding(.top, 20)
            .overlay(alignment: .topTrailing) {
                ResetButton(onPress: viewModel.resetGrid)
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
