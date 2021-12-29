//
//  TheBarView.swift
//  Bar
//
//  Created by David Chen on 11/15/21.
//

import Foundation
import SwiftUI
import Introspect

struct TheBarView: View {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var showingChatView: Bool
    @Binding var showingProfileView: Bool
    
    @State var inTransition = false
    @State var shouldAnimate = false
    
    @State var offset = CGSize()
    @State var showingInviteNotifView = false
    @State var timeElapsed: CGFloat = 0
    @State var messageText = ""
    @State var isKeyboardVisible = false
    
    var showingCourtView: Bool {
        return offset.width == 1000
    }
    
    var body: some View {
        ZStack (alignment: .bottom) {
            ScrollView (.vertical, showsIndicators: false) {
                VStack {
                    TheBarHeaderView(showingProfileView: $showingProfileView)
                        .blur(radius: offset.width * 0.04)
                        .onTapGesture {
                            showingInviteNotifView.toggle()
                        }
                    ZStack {
                        DummySuitorCardView(inTransition: $inTransition, shouldAnimate: $shouldAnimate, offset: $offset)
                        if showingCourtView {
                            CourtView(inTransition: $inTransition, offset: $offset)
                                .transition(.move(edge: .trailing))
                        }
                        SwipeableSuitorCardView(shouldBeInvisible: $inTransition, offset: $offset, isKeyboardVisible: $isKeyboardVisible)
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.77)
                }.introspectScrollView { scrollView in
                    scrollView.isScrollEnabled = isKeyboardVisible
                }
            }
            .disabled(isKeyboardVisible)
            if !showingCourtView {
                VStack {
                    if isKeyboardVisible {
                        Spacer()
                    }
                    BarMessageFieldView(messageText: $messageText, isKeyboardVisible: $isKeyboardVisible)
                        .blur(radius: offset.width * 0.04)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    formatter.hideKeyboard()
                }
                .gesture(DragGesture().onChanged({ value in
                    if value.translation.height > 0 {
                        formatter.hideKeyboard()
                    }
                }))
            }
            if showingInviteNotifView {
                InviteNotifView(showingInviteNotifView: $showingInviteNotifView, timeElapsed: $timeElapsed, showingChatView: $showingChatView)
            }
        }
    }
}

struct TheBarHeaderView: View {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var showingProfileView: Bool
    
    var body: some View {
        HStack {
            Text("THE BAR")
                .font(formatter.font(fontSize: .mediumLarge))
                .tracking(3)
                .shadow(color: formatter.color(.primaryAccent), radius: 0, x: 2, y: 2)
            Spacer()
            Button(action: {
                formatter.hapticFeedback(style: .medium)
                showingProfileView.toggle()
            }, label: {
                Image("TempAF1")
            })
            .frame(width: 20, height: 20)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
            Button(action: {
                formatter.hapticFeedback(style: .medium)
            }, label: {
                Image("SettingsIcon")
            })
        }
        .padding(.horizontal)
        Spacer()
    }
}

struct BarMessageFieldView: View, KeyboardReadable {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var messageText: String
    @Binding var isKeyboardVisible: Bool
    
    var body: some View {
        ZStack (alignment: .leading) {
            if messageText.isEmpty {
                Text("Say something to Tushar!")
                    .transition(.identity)
                    .padding(.leading, 3)
                    .padding(.horizontal, 15)
            }
            HStack {
                TextField("", text: $messageText)
                    .accentColor(formatter.color(.primaryAccent))
                    .padding(.horizontal, 15)
                    .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                        isKeyboardVisible = newIsKeyboardVisible
                    }
                Button {
                    if messageText.isEmpty {
                        formatter.hapticFeedback(style: .soft)
                    } else {
                        formatter.hapticFeedback(style: .light)
                    }
                } label: {
                    Image(systemName: "arrow.up")
                        .font(formatter.iconFont(.small))
                        .padding(7)
                        .background(formatter.color(.primaryAccent))
                        .clipShape(Circle())
                        .opacity(messageText.isEmpty ? 0.4 : 1)
                }
                .padding(.horizontal, 8)
            }
        }
        .font(formatter.font(.regular, fontSize: .medium))
        .foregroundColor(formatter.color(.primaryText))
        .frame(height: 45)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.white, lineWidth: 2)
        )
        .opacity(0.8)
        .padding()
    }
}

struct DummySuitorCardView: View {
    @Binding var inTransition: Bool
    @Binding var shouldAnimate: Bool
    @Binding var offset: CGSize
    
    @State var decoyOffset = CGSize()
    @State var isKeyboardVisible = false
    
    var body: some View {
        ZStack {
            SwipeableSuitorCardView(shouldBeInvisible: $shouldAnimate, offset: $decoyOffset, isKeyboardVisible: $isKeyboardVisible)
            Color.black.opacity(inTransition ? 0 : 0.4).cornerRadius(10)
        }
        .blur(radius: offset.width * 0.04)
        .disabled(true)
    }
}

struct SwipeableSuitorCardView: View {
    
    // Handles the actual swipe gesture
    @EnvironmentObject var formatter: Formatter
    
    @Binding var shouldBeInvisible: Bool
    @Binding var offset: CGSize
    @Binding var isKeyboardVisible: Bool
    
    @State var hidePeriphery = false
    
    var body: some View {
        SuitorCardView(shouldBeInvisible: $shouldBeInvisible, isKeyboardVisible: $isKeyboardVisible, offset: $offset, hidePeriphery: $hidePeriphery, prompts: TempDB().tempPrompts)
            .offset(offset)
            .rotationEffect(Angle(degrees: Double(offset.width) * 0.03))
            .opacity(shouldBeInvisible ? 0 : 1)
            .gesture(
                DragGesture().onChanged({ value in
                    offset.width = value.translation.width * 2
                    offset.height = value.translation.height * 2
                })
                .onEnded({ value in
                    resetOffset(value: value)
                })
            )
            ._onButtonGesture { pressing in
                if hidePeriphery && !pressing {
                    hidePeriphery = false
                }
            } perform: {}
            .simultaneousGesture(LongPressGesture().onChanged({ pressed in
                if !hidePeriphery {
                    hidePeriphery = true
                }
            }))
    }
    
    func resetOffset(value: DragGesture.Value) {
        if value.translation.width >= 100 {
            offset.width = 1000
            shouldBeInvisible.toggle()
        } else if value.translation.width <= -100 {
            offset.width = -1000
            shouldBeInvisible.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                offset = CGSize()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                shouldBeInvisible.toggle()
            }
        } else {
            offset = CGSize()
        }
    }
}

struct SuitorCardView: View {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var shouldBeInvisible: Bool
    @Binding var isKeyboardVisible: Bool
    @Binding var offset: CGSize
    @Binding var hidePeriphery: Bool
    
    @State var currentPhotoIndex = 0
    
    var prompts: [TempPromptData]
    
    var body: some View {
        ZStack {
            // Filler for some kind of media
            Formatter.FittedImage(url: "TempTushar2", radius: 0)
            Rectangle()
                .foregroundColor(.clear)
                .background(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.4), .clear]), startPoint: .top, endPoint: .center))
                .opacity(hidePeriphery ? 0 : 1)
            Color.black.opacity(isKeyboardVisible ? 0.5 : 0)
            VStack (alignment: .leading) {
                HStack {
                    ZStack (alignment: .bottomTrailing) {
                        Formatter.FittedImage(url: "TempTushar1", radius: 0)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Circle()
                            .frame(width: 7, height: 7)
                            .foregroundColor(Color.green)
                    }
                    VStack (alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Tushar, 21")
                                .font(formatter.font(.semiBold, fontSize: .medium))
                            Circle()
                                .frame(width: 4, height: 4)
                            Text("0.2 miles away")
                                .font(formatter.font(.regularItalic, fontSize: .small))
                        }
                        HStack {
                            Text("UC Berkeley")
                                .font(formatter.font(.regular, fontSize: .small))
                            Circle()
                                .frame(width: 4, height: 4)
                            Text("Something Engineer at Apple")
                                .font(formatter.font(.regular, fontSize: .small))
                        }
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    SuitorImageTickerView(currentPhotoIndex: $currentPhotoIndex, maxIndex: 4)
                        .padding(10)
                }
            }
            .padding(10)
            .opacity(hidePeriphery ? 0 : 1)
        }
        .cornerRadius(15)
        .contentShape(Rectangle())
    }
}

struct SuitorImageCarouselView: View {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var shouldBeInvisible: Bool
    @Binding var offset: CGSize
    
    @State var currentPhotoIndex = 0
    
    let images = ["TempPhoto1", "TempPhoto2", "TempPhoto3", "TempPhoto4"]
    
    var body: some View {
        ZStack {
            ZStack {
                Formatter.FittedImage(url: images[currentPhotoIndex], radius: 0)
                    .animation(.none)
                Rectangle()
                    .foregroundColor(.clear)
                    .background(LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.4)]), startPoint: .center, endPoint: .bottom))
                HStack (spacing: 0) {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if currentPhotoIndex > 0 {
                                currentPhotoIndex -= 1
                                formatter.hapticFeedback(style: .medium)
                            } else {
                                formatter.hapticFeedback(style: .rigid)
                            }
                        }
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if images.indices.contains(currentPhotoIndex) {
                                currentPhotoIndex += 1
                                formatter.hapticFeedback(style: .medium)
                            } else {
                                formatter.hapticFeedback(style: .rigid)
                            }
                        }
                }
            }
            VStack {
                HStack {
                    Spacer()
                    HStack (spacing: 5) {
                        Text("Free")
                            .font(formatter.font(.bold, fontSize: .small))
                        Circle()
                            .frame(width: 7, height: 7)
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(formatter.color(.lowContrastWhite))
                    .clipShape(Capsule())
                    .padding(5)
                }
                Spacer()
                HStack {
                    VStack (alignment: .leading, spacing: 0) {
                        HStack {
                            Text("James, 39")
                                .font(formatter.font(.semiBold, fontSize: .medium))
                            Circle()
                                .frame(width: 5, height: 5)
                            Text("14 miles away")
                                .font(formatter.font(.regularItalic, fontSize: .regular))
                        }
                        Text("British Intelligence Officer, MI6")
                            .font(formatter.font(.regular, fontSize: .regular))
                        SuitorImageTickerView(currentPhotoIndex: $currentPhotoIndex, maxIndex: images.count - 1)
                            .padding(.top, 5)
                    }
                    Spacer()
                    Button(action: {
                        formatter.hapticFeedback(style: .heavy)
                        offset.width = 1000
                        shouldBeInvisible.toggle()
                    }, label: {
                        Image(systemName: "suit.heart")
                            .padding(9)
                            .background(formatter.color(.secondaryAccent))
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    })
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(10)
        }
        .frame(height: UIScreen.main.bounds.height * 0.6)
    }
}

struct BasicInfoLabelView: View {
    @EnvironmentObject var formatter: Formatter
    
    let title: String
    let answer: String
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Circle()
                    .frame(width: 7, height: 7)
                    .foregroundColor(formatter.color(.primaryAccent))
                Text(title)
                    .font(formatter.font(.semiBold, fontSize: .small))
                    .tracking(0.5)
            }
            Text(answer)
                .font(formatter.font(.regular, fontSize: .regular))
        }
    }
}

struct SuitorImageTickerView: View {
    @EnvironmentObject var formatter: Formatter
    
    @Binding var currentPhotoIndex: Int
    
    var maxIndex: Int
    
    var body: some View {
        HStack (spacing: 3) {
            ForEach(0...maxIndex, id: \.self) { i in
                Rectangle()
                    .frame(width: i == currentPhotoIndex ? 35 : 7, height: 7)
                    .cornerRadius(3.0)
                    .opacity(i == currentPhotoIndex ? 1 : 0.5)
            }
        }
    }
}

struct PromptCardView: View {
    @EnvironmentObject var formatter: Formatter
    
    let prompt: String
    let response: String
    
    var rightAligned: Bool = true
    
    var body: some View {
        VStack (alignment: rightAligned ? .leading : .trailing, spacing: 5) {
            Text(prompt.uppercased())
                .font(formatter.font(.semiBold, fontSize: .small))
                .tracking(0.5)
            HStack (alignment: .top, spacing: 5) {
                if rightAligned {
                    Image("QuotesIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 33, height: 50)
                }
                Text(response.uppercased())
                    .font(formatter.font(.bold, fontSize: .mediumLarge))
                    .foregroundColor(formatter.color(.highContrastWhite))
                    .tracking(1)
                    .frame(maxWidth: .infinity, alignment: (rightAligned ? .leading : .trailing))
                    .multilineTextAlignment(rightAligned ? .leading : .trailing)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding((rightAligned ? .leading : .trailing), 30)
                if !rightAligned {
                    Image("QuotesIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 33, height: 50)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
            }
        }
        .padding(10)
        .background(formatter.color(.primaryFG))
        .cornerRadius(5)
    }
}

struct TempPromptData: Hashable {
    var prompt: String
    var response: String
    
    init(prompt: String, response: String) {
        self.prompt = prompt
        self.response = response
    }
}

struct TempDB {
    var tempPrompts: [TempPromptData] = [
        TempPromptData(prompt: "If you came over, we could", response: "Bake cookies and watch the Shining"),
        TempPromptData(prompt: "Out of all my friends, I'm the best at", response: "Using Dating Apps"),
        TempPromptData(prompt: "With you, I want to", response: "Rule the world, but it'd be our little world and it'd be made up of really cozy blankets"),
        TempPromptData(prompt: "I'll be surprised if you can", response: "Guess what race I am!")
    ]
}
