//
//  ChatView.swift
//  Bar
//
//  Created by David Chen on 11/19/21.
//

import Foundation
import SwiftUI

struct ChatView: View {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var showingChatView: Bool
    
    var body: some View {
        VStack {
            Text("HELLO!!")
                .font(formatter.font(.boldItalic, fontSize: .extraLarge))
                .onTapGesture {
                    showingChatView.toggle()
                }
        }
    }
}
