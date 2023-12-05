//
//  LetterGridViewCell.swift
//  WordleClone
//
//  Created by Fiona Wilson on 05/12/2023.
//

import SwiftUI

struct LetterGridCellView: View {
    
    var letter: String
    
    var body: some View {
        Text(letter)
            .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
            .foregroundStyle(.black)
            .border(.black, width: 1)
            .font(.largeTitle)
    }
}

#Preview {
    LetterGridViewCell(letter: "L")
}
