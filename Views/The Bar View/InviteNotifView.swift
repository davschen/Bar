//
//  InviteNotifView.swift
//  Bar
//
//  Created by David Chen on 11/17/21.
//

import Foundation
import SwiftUI

struct InviteNotifView: View {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var showingInviteNotifView: Bool
    @Binding var timeElapsed: CGFloat
    @Binding var showingChatView: Bool
    
    @State var animating = false
    @State var shouldShowInstructions = true
    @State var dragOffset: CGFloat = 10
    @State var hasTransitioned = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
            VStack {
                Rectangle()
                    .opacity(0.00001)
                    .frame(maxHeight: hasTransitioned ? 0 : .infinity)
                    
                if shouldShowInstructions {
                    HStack {
                        Text("Swipe Up to Chat")
                            .font(formatter.font(.regularItalic, fontSize: .regular))
                        Image(systemName: "chevron.up")
                            .font(formatter.iconFont(.small))
                    }
                    .offset(y: animating ? -10 : -30).animation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true))
                    .zIndex(0)
                    .onAppear {
                        animating.toggle()
                    }
                }
                Spacer()
                    .frame(height: dragOffset * 0.5)
                Capsule()
                    .frame(width: 50, height: 5)
                    .foregroundColor(formatter.color(.lowContrastWhite))
                Spacer()
                    .frame(height: dragOffset * 0.5)
                
                InvitePreviewView(hasTransitioned: $hasTransitioned)
                
                Spacer()
                    .frame(height: dragOffset * 0.5)
                
                GeometryReader { geometry in
                    ZStack (alignment: .leading) {
                        Capsule()
                            .frame(maxWidth: .infinity)
                            .frame(height: 8)
                            .foregroundColor(.clear)
                        Capsule()
                            .frame(width: geometry.size.width - timeElapsed * geometry.size.width / 10)
                            .frame(height: 8)
                            .foregroundColor(formatter.color(.secondaryAccent))
                    }
                    .animation(.easeInOut(duration: 1))
                }
                .frame(height: 8)
                .zIndex(2)
                .onReceive(timer) { value in
                    if timeElapsed < 10 {
                        timeElapsed += 1
                    } else {
                        showingInviteNotifView.toggle()
                        timeElapsed = 0
                        timer.upstream.connect().cancel()
                    }
                }
                Spacer()
                    .frame(height: dragOffset * 0.5)
            }
            .contentShape(Rectangle())
            .padding(.horizontal, hasTransitioned ? 0 : 10)
        }
        .gesture(
            DragGesture().onChanged({ value in
                expandOnDrag(value: value)
            })
            .onEnded({ value in
                endDrag()
            })
        )
    }
    
    func expandOnDrag(value: DragGesture.Value) {
        if value.translation.height < 0 {
            if value.translation.height > -150
                && value.translation.height < -140 {
                if !hasTransitioned {
                    formatter.hapticFeedback(style: .heavy)
                    formatter.hapticFeedback(style: .heavy)
                    hasTransitioned = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showingChatView.toggle()
                    }
                }
            }
            shouldShowInstructions = false
            dragOffset = abs(value.translation.height)
        }
    }
    
    func endDrag() {
        if !hasTransitioned {
            withAnimation(.spring()) {
                dragOffset = 10
                hasTransitioned = false
            }
        }
    }
}

struct InvitePreviewView: View {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var hasTransitioned: Bool
    
    var body: some View {
        HStack {
            if !hasTransitioned {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Formatter.FittedImage(url: "Suitor1", radius: 5)
                            .frame(width: 80, height: 80)
                        Formatter.FittedImage(url: "Suitor2", radius: 5)
                            .frame(width: 80, height: 80)
                        Formatter.FittedImage(url: "Suitor3", radius: 5)
                            .frame(width: 80, height: 80)
                    }
                }
                VStack (spacing: 0) {
                    Image("TapIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 46)
                    Text("Ana wants to chat!")
                        .font(formatter.font(.boldItalic, fontSize: .regular))
                }
            } else {
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.clear)
            }
        }
        .padding(10)
        .frame(height: hasTransitioned ? UIScreen.main.bounds.height + 20 : nil)
        .background(formatter.color(hasTransitioned ? .primaryBG : .secondaryFG))
        .cornerRadius(hasTransitioned ? 0 : 10)
        .transition(.move(edge: .bottom))
        .zIndex(1)
    }
}
