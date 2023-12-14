//
//  ResetButton.swift
//  WordleClone
//
//  Created by Fiona Wilson on 14/12/2023.
//

import SwiftUI

struct ResetButton: View {
    
    var onPress: () -> Void
    
    var body: some View {
        Button {
            onPress()
        } label: {
            Image(systemName: "arrow.circlepath")
                .foregroundColor(Color(UIColor.label))
                .padding(20)
        }
    }
}

#Preview {
    ResetButton(onPress: {})
}
