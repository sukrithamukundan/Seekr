//
//  MainTabScreen.swift
//  Seekr
//
//  Created by Sukritha K K on 15/07/25.
//

import SwiftUI

struct MainTabScreen: View {
    @State private var sheetDetent: PresentationDetent = .height(80)
    @State private var showBottomSheet: Bool = false

    @State private var sheetHeight: CGFloat = 0
    @State private var animationDuration: CGFloat = 0
    @State private var toolbarOpacity: CGFloat = 1
    @State private var safeAreaBottomInset: CGFloat = 0
    var body: some View {
        ZStack {
            TabView {
                LandingScreen()
                    .tabItem { Label("Explore", systemImage: "house") }

                Text("Saved/Favorites")
                    .tabItem { Label("Saved", systemImage: "bookmark") }
                ScrollView {
                    Text("Profile & Settings")
                }
                .tabItem { Label("You", systemImage: "person.circle") }
            }
            .tabBarMinimizeBehavior(.onScrollDown)
            .tabViewBottomAccessory {
                SearchBarView()
                    .onTapGesture {
                        sheetDetent = .height(350)
                        showBottomSheet = true
                    }
            }
        }
        .sheet(isPresented: $showBottomSheet) {
            BottomSheetView(sheetDetent: $sheetDetent)
                .presentationDetents([.height(0), .height(350), .large], selection: $sheetDetent)
                .presentationBackgroundInteraction(.enabled)
                .presentationCornerRadius(isiOS26 ? nil : 30)
                .presentationBackground {
                    if !isiOS26 {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onGeometryChange(for: CGFloat.self) {
                    max(min($0.size.height, 400 + safeAreaBottomInset), 0)
                } action: { oldValue, newValue in
                    if sheetDetent == .height(0) {
                        showBottomSheet = false
                    }

                    /// Limiting the offset to 300, so that opacity effect will be visible
                    sheetHeight = min(newValue, 350 + safeAreaBottomInset)

                    /// Calulating Opacity
                    let progress = max(min((newValue - (350 + safeAreaBottomInset)) / 50, 1), 0)
                    toolbarOpacity = 1 - progress

                    /// Calculating Animation Duration
                    let diff = abs(newValue - oldValue)
                    let duration = max(min(diff / 100, maxAnimationDuration), 0)
                    animationDuration = duration
                }
                .ignoresSafeArea()
                .interactiveDismissDisabled()
        }
    }

    var maxAnimationDuration: CGFloat {
        return isiOS26 ? 0.25 : 0.18
    }
}

#Preview {
    MainTabScreen()
}

struct BottomSheetView: View {
    @Binding var sheetDetent: PresentationDetent
    /// Bottom Sheet Properties
    @State private var searchText: String = ""
    @FocusState var isFocused: Bool
    var body: some View {
        ScrollView(.vertical) {
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack(spacing: 10) {
                TextField("Search...", text: $searchText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.gray.opacity(0.25), in: .capsule)
                    .focused($isFocused)

                /// Profile/Close Button for Search Field
                Button {
                    if isFocused {
                        isFocused = false
                    } else {
                        /// Profile Button Action
                    }
                } label: {
                    ZStack {
                        if isFocused {
                            Group {
                                if #available(iOS 26, *) {
                                    Image(systemName: "xmark")
                                        .frame(width: 48, height: 48)
                                        .glassEffect(in: .circle)
                                } else {
                                    Image(systemName: "xmark")
                                        .frame(width: 48, height: 48)
                                        .background(.ultraThinMaterial, in: .circle)
                                }
                            }
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary)
                            .transition(.blurReplace)
                        } else {
                            Text("BV")
                                .font(.title2.bold())
                                .frame(width: 48, height: 48)
                                .foregroundStyle(.white)
                                .background(.gray, in: .circle)
                                .transition(.blurReplace)
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
            .frame(height: 80)
            .padding(.top, 5)
        }
        /// Animating Focus Changes
        .animation(.interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0), value: isFocused)
        /// Updating Sheet size when textfield is active
        .onChange(of: isFocused) { _, newValue in
            sheetDetent = newValue ? .large : .height(350)
        }
    }
}

struct SearchBarView: View {
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            Text("Find a quiet café with good Wi-Fi.")
                .foregroundColor(.primary)
            Spacer(minLength: 0)
            Button {
                // Handle mic action
            } label: {
                Image(systemName: "mic.fill")
                    .contentShape(.rect)
                    .foregroundColor(.blue)
            }
        }
        .foregroundStyle(Color.primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
//        .background(.ultraThinMaterial) // Optional: frosted look
//        .clipShape(Capsule())
//        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
