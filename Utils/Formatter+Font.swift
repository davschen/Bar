//
//  Formatter+Font.swift
//  Bar
//
//  Created by David Chen on 11/15/21.
//

import Foundation
import SwiftUI

extension Formatter {
    func font(_ fontStyle: FontStyle = .bold, fontSize: FontSize = .medium) -> Font {
        var styleString = ""
        var sizeFloat: CGFloat = 15
        
        switch fontStyle {
        case .regular: styleString = "Regular"
        case .regularItalic: styleString = "Italic"
        case .medium: styleString = "Medium"
        case .semiBold: styleString = "Demi Bold"
        case .boldItalic: styleString = "Bold Italic"
        case .extraBold: styleString = "Heavy"
        default: styleString = "Bold"
        }
        
        switch fontSize {
        case .micro: sizeFloat = 8
        case .small: sizeFloat = 12
        case .regular: sizeFloat = 14
        case .medium: sizeFloat = 17
        case .mediumLarge: sizeFloat = 20
        case .semiLarge: sizeFloat = 25
        case .large: sizeFloat = 30
        case .extraLarge: sizeFloat = 35
        }
        
        return Font.custom("Avenir Next " + styleString, size: sizeFloat)
    }
    
    func font(_ fontStyle: FontStyle = .bold, _ fontSizeFloat: CGFloat = 14) -> Font {
        var styleString = ""
        
        switch fontStyle {
        case .regular: styleString = "Regular"
        case .regularItalic: styleString = "Italic"
        case .medium: styleString = "Medium"
        case .semiBold: styleString = "Demi Bold"
        case .boldItalic: styleString = "Bold Italic"
        case .extraBold: styleString = "Heavy"
        default: styleString = "Bold"
        }
        
        return Font.custom("Avenir Next " + styleString, size: fontSizeFloat)
    }
    
    func iconFont(_ systemFontSize: SystemFontSize = .medium, weight: Font.Weight = .bold) -> Font {
        return .system(size: systemFontSize.rawValue, weight: weight)
    }
}

enum FontStyle {
    case regular, regularItalic, medium, semiBold, bold, boldItalic, extraBold
}

enum FontSize {
    case micro, small, regular, medium, mediumLarge, semiLarge, large, extraLarge
}

enum SystemFontSize: CGFloat {
    case small = 15
    case medium = 20
    case mediumLarge = 25
    case large = 30
}
