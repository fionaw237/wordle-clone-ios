//
//  LetterGridViewCell.swift
//  WordleClone
//
//  Created by Fiona Wilson on 05/12/2023.
//

import SwiftUI

struct LetterGridCellView: View {
    
    var cellModel: LetterGridCellModel
    
    var body: some View {
        Text(cellModel.letter)
            .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
            .foregroundStyle(Color(UIColor.label))
            .background(cellModel.backgroundColour)
            .border(cellModel.borderColour ?? .clear, width: 1)
            .font(.largeTitle)
    }
}

#Preview {
    LetterGridCellView(cellModel: LetterGridCellModel(letter: "A"))
}
