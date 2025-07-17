//
//  MainTabScreen.swift
//  Seekr
//
//  Created by Sukritha K K on 15/07/25.
//

import FoundationModels
import MapKit
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
               TravelProfileView()
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
                .presentationDetents([.height(1), .height(350), .large], selection: $sheetDetent)
                .presentationBackgroundInteraction(.enabled)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .onGeometryChange(for: CGFloat.self) {
//                    max(min($0.size.height, 400 + safeAreaBottomInset), 0)
//                } action: { oldValue, newValue in
//                    if sheetDetent == .height(0) {
//                        showBottomSheet = false
//                    }
//
//                    /// Limiting the offset to 300, so that opacity effect will be visible
//                    sheetHeight = min(newValue, 350 + safeAreaBottomInset)
//
//                    /// Calulating Opacity
//                    let progress = max(min((newValue - (350 + safeAreaBottomInset)) / 50, 1), 0)
//                    toolbarOpacity = 1 - progress
//
//                    /// Calculating Animation Duration
//                    let diff = abs(newValue - oldValue)
//                    let duration = max(min(diff / 100, maxAnimationDuration), 0)
//                    animationDuration = duration
//                }
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
    @FocusState var isFocused: Bool
    @State var planner: ItineraryPlanner?
    @StateObject private var locationManager = LocationManager()
    var body: some View {
        ScrollView(.vertical) {
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            NavigationStack {
                VStack {
                    NeuralSearchView(query: $locationManager.naturalLanguageQuery)
                    if let landmark = locationManager.userLandmark {
                        ListingScreen(landmark: landmark)
                    }
                }
            }
        }

        .task {
            if let coordinate = locationManager.location?.coordinate {
                await locationManager.getLocationName(from: coordinate)
                if let landmark = locationManager.userLandmark {
                    planner = ItineraryPlanner(landmark: landmark)
                    planner?.prewarm()
                    Task { @MainActor in
                        try await requestItinerary()
                    }
                }
            }
        }
        .environment(planner)
        /// Animating Focus Changes
        .animation(.interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0), value: isFocused)
        /// Updating Sheet size when textfield is active
        .onChange(of: isFocused) { _, newValue in
            sheetDetent = newValue ? .large : .height(350)
        }
    }

    func requestItinerary() async throws {
        do {
            try await planner?.suggestItinerary()
        } catch {
            planner?.error = error
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
                    .foregroundColor(.accentColor)
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

struct NeuralSearchView: View {
    @Binding var query: String
    @State private var requestedItinerary: Bool = false
    @Environment(ItineraryPlanner.self) var planner: ItineraryPlanner?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Tell me what you're looking for…\n'Find a quiet café with outdoor seating and good WiFi near MG Road'", text: $query, axis: .vertical)
                .lineLimit(2 ... 6)
                .padding(12)
                .foregroundColor(.white)
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
//                    .scrollContentBackground(.hidden)
            HStack {
                HStack(spacing: 16) {
                    GradientCircleButton(icon: "mic.fill")
                    GradientCircleButton(icon: "camera.fill", plain: true)
                }

                Spacer()

                Button(action: {
                    Task { @MainActor in
                        try await requestItinerary()
                    }
                }) {
                    Label("Search", systemImage: "sparkles")
                        .fontWeight(.semibold)
                        .frame(width: 100, height: 44)
                        .background(
                            LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .padding()
    }

    func requestItinerary() async throws {
        requestedItinerary = true
        do {
            try await planner?.suggestItinerary()
        } catch {
            planner?.error = error
        }
    }
}

struct GradientCircleButton: View {
    let icon: String
    var plain: Bool = false

    var body: some View {
        ZStack {
            if plain {
                Circle()
                    .fill(Color.white.opacity(0.1))
            } else {
                Circle()
                    .fill(LinearGradient.bg)
            }

            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
        }
        .frame(width: 44, height: 44)
    }
}


extension LinearGradient{
  static let bg = LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
}
