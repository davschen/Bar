//
//  ScaleButtonScale.swift
//  Bar
//
//  Created by David Chen on 11/17/21.
//

import Foundation
import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
    }
}
