//
//  ContentView.swift
//  WordleClone
//
//  Created by Fiona Wilson on 01/12/2023.
//

import SwiftUI

struct GameScreenView: View {
        
    @StateObject private var viewModel = GameScreenViewModel()
    
    var body: some View {
        VStack {
            Text("Wordle clone")
        }
    }
}

#Preview {
    GameScreenView()
}
