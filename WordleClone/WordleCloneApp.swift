//
//  WordleCloneApp.swift
//  WordleClone
//
//  Created by Fiona Wilson on 01/12/2023.
//

import SwiftUI

@main
struct WordleCloneApp: App {
    
    let viewModel = GameScreenViewModel(
        wordGenerator: WordGenerator(),
        dictionaryService: DictionaryService(httpClient: HttpClient())
    )
    
    var body: some Scene {
        WindowGroup {
            GameScreenView(viewModel: viewModel)
        }
    }
}
