//
//  ContentView.swift
//  Bar
//
//  Created by David Chen on 11/15/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var formatter = Formatter()
    
    @State var showingProfileView = false
    @State var showingChatView = false
    
    @State var profileViewOffset: CGFloat = 0
    
    init() {
        UIScrollView.appearance().keyboardDismissMode = .interactive
    }
    
    var body: some View {
        ZStack {
            formatter.color(.primaryBG).edgesIgnoringSafeArea(.all)
            if showingChatView {
                ChatView(showingChatView: $showingChatView)
                    .environmentObject(formatter)
            } else {
                TheBarView(showingChatView: $showingChatView, showingProfileView: $showingProfileView)
                    .environmentObject(formatter)
                if showingProfileView {
                    ProfileView(showingProfileView: $showingProfileView, offset: $profileViewOffset)
                        .environmentObject(formatter)
                        .offset(y: profileViewOffset)
                }
            }
        }
        .foregroundColor(formatter.color(.primaryText))
        .animation(.easeInOut.speed(1.5))
        .font(formatter.font(.bold, fontSize: .medium))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
