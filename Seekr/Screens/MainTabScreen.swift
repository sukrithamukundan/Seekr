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

    @State var planner: ItineraryPlanner?
    @StateObject private var locationManager = LocationManager()
    var body: some View {
        ZStack {
            TabView {
                LandingScreen()
                    .tabItem { Label("Explore", systemImage: "house") }
                ItineraryScreen()
                    .tabItem { Label("Itinerary", systemImage: "sparkles") }

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
        }.task {
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
        .sheet(isPresented: $showBottomSheet) {
            BottomSheetView(naturalLanguageQuery: $locationManager.naturalLanguageQuery, userLandmark: $locationManager.userLandmark)
                .presentationDetents([.height(1), .height(350), .large], selection: $sheetDetent)
                .presentationBackgroundInteraction(.enabled)
                .ignoresSafeArea()
                .interactiveDismissDisabled()
        }
        .environment(planner)
        .environmentObject(locationManager)
    }

    var maxAnimationDuration: CGFloat {
        return isiOS26 ? 0.25 : 0.18
    }

    func requestItinerary() async throws {
        do {
            try await planner?.suggestItinerary()
        } catch {
            planner?.error = error
        }
    }
}

#Preview {
    MainTabScreen()
}

struct BottomSheetView: View {
    @Binding var naturalLanguageQuery: String
    @Binding var userLandmark: Landmark?
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    NeuralSearchView(query: $locationManager.naturalLanguageQuery)
                    if locationManager.naturalLanguageQuery.isEmpty {
                        ScheduleAssistantCard()
                        HealthInsightsCard()
                    }

                    if let landmark = locationManager.userLandmark {
                        ListingScreen(landmark: landmark)
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }
}

struct SearchBarView: View {
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            Text("Find a quiet café with good Wi-Fi.")
                .font(.caption)
                .foregroundColor(.secondary)
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
    }
}

struct NeuralSearchView: View {
    @Binding var query: String
    @State private var requestedItinerary: Bool = false
    @Environment(ItineraryPlanner.self) var planner: ItineraryPlanner?
    @FocusState var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Tell me what you're looking for…\n'Find a quiet café with outdoor seating and good WiFi near MG Road'", text: $query, axis: .vertical)
                .lineLimit(2 ... 6)
                .padding(12)
                .foregroundColor(.white)
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                .focused($isFocused)
//                    .scrollContentBackground(.hidden)
            HStack {
                HStack(spacing: 16) {
                    GradientCircleButton(icon: "mic.fill")
                    GradientCircleButton(icon: "camera.fill", plain: true)
                }

                Spacer()

                Button(action: {
                    isFocused = false
                    Task { @MainActor in
                        try await requestItinerary()
                    }
                }) {
                    Label(planner?.isLoading == true ? "Generating..." : "Search", systemImage: "sparkles")
                        .fontWeight(.semibold)
                        .frame(height: 44)
                        .padding(.horizontal)
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
        planner?.landmark.naturalLanguageQuery = query
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

extension LinearGradient {
    static let bg = LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
}
