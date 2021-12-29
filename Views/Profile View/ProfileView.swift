//
//  ProfileView.swift
//  Bar
//
//  Created by David Chen on 12/20/21.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var showingProfileView: Bool
    @Binding var offset: CGFloat
    
    @State var selectedTab: PVMenuItem = .profile
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            VStack (spacing: 15) {
                VStack (spacing: 15) {
                    ZStack (alignment: .bottomTrailing) {
                        Formatter.FittedImage(url: "TempTusharPF", radius: 0)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(formatter.color(.primaryAccent), lineWidth: 10))
                            .frame(width: 130, height: 130)
                            .padding(.top, 5)
                        Image(systemName: "plus")
                            .font(formatter.iconFont(.small))
                            .foregroundColor(formatter.color(.primaryBG))
                            .padding(5)
                            .background(formatter.color(.highContrastWhite))
                            .clipShape(Circle())
                            .offset(x: -4, y: -4)
                    }
                    Text("Tushar Sondhi")
                        .font(formatter.font(.bold, 24))
                }
                HStack {
                    ProfileTabLabelView(selectedTab: $selectedTab, tabLabel: "Profile", identityTab: .profile)
                    Spacer()
                    ProfileTabLabelView(selectedTab: $selectedTab, tabLabel: "Preferences", identityTab: .preferences)
                    Spacer()
                    ProfileTabLabelView(selectedTab: $selectedTab, tabLabel: "Settings", identityTab: .settings)
                }
                .font(formatter.font(.bold, fontSize: .mediumLarge))
                ZStack {
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(formatter.color(.primaryFG))
                .cornerRadius(10)
            }
            
            Button {
                showingProfileView.toggle()
            } label: {
                Image(systemName: "xmark")
                    .font(formatter.iconFont(.mediumLarge, weight: .bold))
            }
        }
        .padding(30)
        .background(formatter.color(.primaryBG))
        .cornerRadius(30)
        .transition(.move(edge: .bottom))
        .animation(.easeInOut.speed(1))
        .contentShape(Rectangle())
        .gesture(DragGesture()
                    .onChanged({ value in
                        if value.translation.height > 0 {
                            offset = value.translation.height * 0.5
                        }
                    })
                    .onEnded({ value in
                        if value.translation.height > 50 {
                            offset = 1000
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showingProfileView.toggle()
                                offset = 0
                            }
                        } else {
                            offset = 0
                        }
                    }))
    }
}

struct ProfileTabLabelView: View {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var selectedTab: PVMenuItem
    
    let tabLabel: String
    let identityTab: PVMenuItem
    
    var body: some View {
        Button {
            selectedTab = identityTab
        } label: {
            Text(tabLabel)
                .opacity(selectedTab == identityTab ? 1 : 0.3)
        }
    }
}

enum PVMenuItem {
    case profile, preferences, settings
}
