//
//  LetterGridCellModel.swift
//  WordleClone
//
//  Created by Fiona Wilson on 05/12/2023.
//

import Foundation
import SwiftUI

struct LetterGridCellModel: Identifiable {
    var id = UUID()
    var letter: String = ""
    var backgroundColour: Color = Color(UIColor.systemBackground)
}
