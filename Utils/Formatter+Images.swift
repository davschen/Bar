//
//  Formatter+Images.swift
//  Bar
//
//  Created by David Chen on 11/15/21.
//

import Foundation
import SwiftUI

extension Formatter {
    struct FittedImage: View {
        let url: String
        let radius: CGFloat
        
        var body: some View {
            Image(url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, minHeight: 0)
                .cornerRadius(radius)
                .clipped()
        }
    }
}
