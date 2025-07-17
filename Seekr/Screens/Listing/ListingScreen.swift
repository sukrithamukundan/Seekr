//
//  ListingScreen.swift
//  Seekr
//
//  Created by Sukritha K K on 17/07/25.
//

import FoundationModels
import SwiftUI

struct ListingScreen: View {
    let landmark: Landmark
    private let model = SystemLanguageModel.default

    var body: some View {
        switch model.availability {
        case .available:
            // Inject planner environment here if needed
            ListingView(landmark: landmark)
        case .unavailable(.appleIntelligenceNotEnabled):
            MessageView(
                landmark: self.landmark,
                message: """
                Trip Planner is unavailable because \
                Apple Intelligence has not been turned on.
                """
            )
        case .unavailable(.modelNotReady):
            MessageView(
                landmark: self.landmark,
                message: "Trip Planner isn't ready yet. Try again later."
            )
        default:
            ScrollView {
                ProgressView()
            }
        }
    }
}

struct ListingView: View {
    @Environment(ItineraryPlanner.self) var planner: ItineraryPlanner?

    @State private var requestedItinerary: Bool = false
    let landmark: Landmark
    var body: some View {
        if let error = planner?.error {
            MessageView(error: error, landmark: landmark)
        } else {
            ScrollView {
                VStack {
                    Text("AI Recommended for You")
                        .font(.headline)
                        .foregroundStyle(.blue, .purple)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let itinerary = planner?.itinerary, let activities = itinerary.activities {
                        ForEach(activities) { activity in
                            ActivityCardView(activity: activity)
                        }

                    } else if let planner {
                        Image(systemName: "sparkles")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(Color.blue, Color.purple)
                            .animation(.default, value: planner.pointOfInterestTool.lookupHistory.count)
                            .symbolEffect(.breathe, isActive: true)
                            .padding(.top)
                        Text("Generating...")
                    }
                }.padding()
            }
        }
    }
}
