//
//  Formatter+Color.swift
//  Bar
//
//  Created by David Chen on 11/15/21.
//

import Foundation
import SwiftUI

extension Formatter {
    func color(_ colorType: ColorType) -> Color {
        var colorString = ""
        switch colorType {
        case .highContrastWhite: colorString = "High Contrast White"
        case .lowContrastWhite: colorString = "Low Contrast White"
        case .mediumContrastWhite: colorString = "Medium Contrast White"
        case .primaryAccent: colorString = "Primary Accent"
        case .primaryBG: colorString = "Primary BG"
        case .primaryText: colorString = "Primary Text"
        case .secondaryBG: colorString = "Secondary BG"
        case .secondaryAccent: colorString = "Secondary Accent"
        case .secondaryFG: colorString = "Secondary FG"
        default: colorString = "Primary FG"
        }
        return Color(colorString)
    }
}

enum ColorType {
    case highContrastWhite, lowContrastWhite, mediumContrastWhite, primaryAccent, primaryBG, primaryFG, primaryText, secondaryAccent, secondaryBG, secondaryFG
}
