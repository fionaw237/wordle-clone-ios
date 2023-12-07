//
//  ContentView.swift
//  WordleClone
//
//  Created by Fiona Wilson on 01/12/2023.
//

import SwiftUI

struct GameScreenView: View {
    
    let columns: [GridItem] = [
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem(),
        GridItem()
    ]
    
    @StateObject private var viewModel = GameScreenViewModel(wordGenerator: WordGenerator())
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.gridCellModels) { cellModel in
                    LetterGridCellView(cellModel: cellModel)
                }
            }
            .padding(.top, 80)
            .onAppear {
                viewModel.newGame()
            }
            
            
            Spacer()
            HStack {
                Button {
                    viewModel.letterKeyPressed("A")
                } label: {
                    Text("A")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                
                Button {
                    viewModel.letterKeyPressed("P")
                } label: {
                    Text("P")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                
                Button {
                    viewModel.letterKeyPressed("L")
                } label: {
                    Text("L")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                
                Button {
                    viewModel.letterKeyPressed("E")
                } label: {
                    Text("E")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                
                Button {
                    viewModel.letterKeyPressed("T")
                } label: {
                    Text("T")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                Button {
                    viewModel.letterKeyPressed("C")
                } label: {
                    Text("C")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                
            }
            
            HStack {
                Button {
                    viewModel.letterKeyPressed("S")
                } label: {
                    Text("S")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                
                Button {
                    viewModel.letterKeyPressed("O")
                } label: {
                    Text("O")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                
                Button {
                    viewModel.letterKeyPressed("H")
                } label: {
                    Text("H")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                
                Button {
                    viewModel.letterKeyPressed("D")
                } label: {
                    Text("D")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                
                Button {
                    viewModel.letterKeyPressed("R")
                } label: {
                    Text("R")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                Button {
                    viewModel.letterKeyPressed("B")
                } label: {
                    Text("B")
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                }
                
            }
            
            Button {
                viewModel.enterKeyPressed()
            } label: {
                Text("Enter!")
            }
            
            Button {
                viewModel.deleteKeyPressed()
            } label: {
                Text("Delete!")
            }
        }
        .padding()
        Spacer()
    }
}


#Preview {
    GameScreenView()
}
