//
//  GameCompletedView.swift
//  WordleClone
//
//  Created by Fiona Wilson on 13/12/2023.
//

import SwiftUI

struct GameCompletedView: View {
    
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack {
            
        }
        .frame(width: 300, height: 525)
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
    GameCompletedView(isVisible: .constant(true))
}
