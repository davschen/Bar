//
//  CourtView.swift
//  Bar
//
//  Created by David Chen on 11/16/21.
//

import Foundation
import SwiftUI
import Introspect

struct CourtView: View, KeyboardReadable {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var inTransition: Bool
    @Binding var offset: CGSize
    
    @State var messageText = ""
    @State var isKeyboardVisible = false
    @State var hasSentMessage = false
    @State var timeElapsed: CGFloat = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            ScrollView (.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 10) {
                    Text("James")
                        .font(formatter.font(.semiBold, fontSize: .extraLarge))
                        .padding(.horizontal, 20)
                    ZStack (alignment: .topTrailing) {
                        Formatter.FittedImage(url: "TempPhoto2", radius: 10)
                            .frame(height: UIScreen.main.bounds.height * 0.4, alignment: .top)
                        Image("TapIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 86)
                            .offset(y: -60)
                    }
                    .padding(.horizontal, 20)
                }
                .transition(.move(edge: .bottom))
                if !hasSentMessage {
                    FirstMessageTextFieldView(inTransition: $inTransition, offset: $offset, messageText: $messageText, isKeyboardVisible: $isKeyboardVisible, hasSentMessage: $hasSentMessage)
                        .transition(.move(edge: .top))
                } else {
                    VStack {
                        if timeElapsed <= 10 {
                            GeometryReader { geometry in
                                ZStack (alignment: .leading) {
                                    Capsule()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 8)
                                        .foregroundColor(formatter.color(.lowContrastWhite))
                                    Capsule()
                                        .frame(width: geometry.size.width - timeElapsed * geometry.size.width / 10)
                                        .frame(height: 8)
                                        .foregroundColor(formatter.color(.secondaryAccent))
                                }
                                .animation(.linear(duration: 1))
                                .onReceive(timer) { input in
                                    timeElapsed += 1
                                }
                            }
                        }
                        Text("James will have 10 seconds to respond to your tap. If he accepts, you will have 10 minutes to chat him before potentially exchanging contacts.")
                            .font(formatter.font(.regularItalic, fontSize: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(15)
                            .background(formatter.color(.primaryFG))
                            .cornerRadius(10)
                        Button {
                            if timeElapsed < 10 {
                                return
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                offset = CGSize()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                inTransition.toggle()
                            }
                        } label: {
                            Text(timeElapsed < 10 ? "Back (\(Int(max(10 - timeElapsed, 0))))" : "Back")
                                .foregroundColor(formatter.color(.primaryBG))
                                .padding(.vertical, 15)
                                .padding(.horizontal, 50)
                                .background(formatter.color(.highContrastWhite))
                                .clipShape(Capsule())
                                .opacity(timeElapsed <= 10 ? 0.4 : 1)
                        }
                    }
                    .transition(.move(edge: .bottom))
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct FirstMessageTextFieldView: View, KeyboardReadable {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var inTransition: Bool
    @Binding var offset: CGSize
    
    @Binding var messageText: String
    @Binding var isKeyboardVisible: Bool
    @Binding var hasSentMessage: Bool
    
    var body: some View {
        HStack {
            ZStack (alignment: .leading) {
                Text("Drop your line...")
                    .opacity(messageText.count == 0 ? 1 : 0)
                    .font(formatter.font(.regular))
                    .foregroundColor(formatter.color(.lowContrastWhite))
                    .animation(.none)
                CustomTextField(text: $messageText, isFirstResponder: true)
                    .accentColor(formatter.color(.primaryAccent))
                    .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                        isKeyboardVisible = newIsKeyboardVisible
                    }
                    .introspectTextField { textfield in
                      textfield.returnKeyType = .done
                    }
            }
            Button {
                if messageText.isEmpty {
                    formatter.hapticFeedback(style: .soft)
                } else {
                    formatter.hapticFeedback(style: .light)
                    hasSentMessage.toggle()
                }
            } label: {
                Image(systemName: "arrow.up")
                    .font(formatter.iconFont(.small))
                    .padding(7)
                    .background(formatter.color(.primaryAccent))
                    .clipShape(Circle())
                    .opacity(messageText.isEmpty ? 0.4 : 1)
            }
        }
        .frame(height: 30)
        .padding(20)
        .background(formatter.color(.secondaryFG))
        .cornerRadius(isKeyboardVisible ? 0 : 5)
        .padding(.horizontal, isKeyboardVisible ? 0 : 20)
        if !isKeyboardVisible {
            Button {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    offset = CGSize()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    inTransition.toggle()
                }
            } label: {
                Text("jk lmao")
                    .padding(.top, 20)
            }
        }
    }
}
