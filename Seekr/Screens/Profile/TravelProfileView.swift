//
//  TravelProfileView.swift
//  Seekr
//
//  Created by Jishnu Raj  on 17/07/25.
//

import SwiftUI

struct TravelProfileView: View {
    // MARK: - User Preferences Stored with @AppStorage

    @AppStorage("useHealthData") private var useHealthData = true
    @AppStorage("calendarAwareness") private var calendarAwareness = true
    @AppStorage("personalizedSuggestions") private var personalizedSuggestions = true
    @AppStorage("budgetTravel") private var budgetTravel = false
    @AppStorage("soloTravel") private var soloTravel = false
    @AppStorage("familyFriendly") private var familyFriendly = false
    @AppStorage("petFriendly") private var petFriendly = false
    @AppStorage("adventureSeeker") private var adventureSeeker = true
    @AppStorage("culturalExplorer") private var culturalExplorer = true

    @StateObject private var healthManager = HealthManager()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                Section {
                    VStack(spacing: 24) {
                        discoverySummary

                        savedPlacesSection

                        preferencesSection

                        privacySection
                    }
                    .padding()
                    .padding(.vertical)
                    .glassEffect(in: .rect(topLeadingRadius: 0, bottomLeadingRadius: 16, bottomTrailingRadius: 16, topTrailingRadius: 0, style: .circular))

                    .padding(.bottom, 64)
                } header: {
                    headerSection
                        .padding()
                        .padding(.vertical, 4)
                        .glassEffect(in: .rect(topLeadingRadius: 16, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 16, style: .circular))
                }
            }
            .padding()
            .tint(.accent)
        }
        // Travel-themed background image (add an asset named "travelBackground" to your Assets catalog)

        .background(
            //// LinearGradient.bg
            Image("profilebg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .bottom, spacing: 16) {
            Circle()
                .fill(.gray.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay {
                    if let avatarImage = fetchUserAvatar() {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                    } else {
                        Image("profile-pic")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.purple)
                            .clipShape(Circle())
                    }
                }

            VStack(alignment: .leading) {
                Text("Hi Sukritha 👋")
                    .font(.title2.bold())
                Text("City Explorer since 2025")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Discovery Summary

    private var discoverySummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Discovery summary")
                .font(.headline)
                .foregroundColor(.white)
            HStack(spacing: 32) {
                summaryItem(title: "Places", value: "34")
                summaryItem(title: "Steps", value: "\(healthManager.stepCount.formatted(.number.notation(.compactName)))")
                summaryItem(title: "Favorites", value: "9")
            }
        }
    }

    private func summaryItem(title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Saved Places

    private var savedPlacesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Saved")
                .font(.headline)
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    savedCard(title: "Cubbon Park", subtitle: "Bengaluru", imageName: "saved2")
                    savedCard(title: "Lahe Lahe Café", subtitle: "Bengaluru", imageName: "saved1")
                }
                .contentMargins(12)
            }
        }
    }

    private func savedCard(title: String, subtitle: String, imageName: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(.white)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    // MARK: - Preferences

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preferences".capitalized)
                .font(.headline)
                .foregroundColor(.white)

            preferenceToggle("Use Health Data", $useHealthData)
            preferenceToggle("Calendar Awareness", $calendarAwareness)
            preferenceToggle("Personalized Suggestions", $personalizedSuggestions)
            preferenceToggle("Budget Travel", $budgetTravel)
            preferenceToggle("Solo Travel", $soloTravel)
            preferenceToggle("Family Friendly", $familyFriendly)
            preferenceToggle("Pet Friendly", $petFriendly)
            preferenceToggle("Adventure Seeker", $adventureSeeker)
            preferenceToggle("Cultural Explorer", $culturalExplorer)
        }
    }

    private func preferenceToggle(_ title: String, _ binding: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: binding)
                .labelsHidden()
                .toggleStyle(.switch)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Privacy Section

    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Permissions & Privacy")
                .font(.headline)
                .foregroundColor(.white)

            NavigationLink(destination: Text("Privacy Settings")) {
                HStack {
                    Text("Manage Privacy Settings")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .foregroundColor(.white)
            }
        }
    }

    // MARK: - Glass Background for Container
}





#Preview {
    TravelProfileView()
}
