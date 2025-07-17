//
//  ItineraryScreen.swift
//  Seekr
//
//  Created by Sukritha K K on 17/07/25.
//

import FoundationModels
import MapKit
import SwiftUI

struct ItineraryScreen: View {
    @State var planner: ItineraryPlanner?
    @StateObject private var locationManager = LocationManager()
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    if let landmark = locationManager.userLandmark {
                        TripPlanningView(landmark: landmark)
                    }
                }
            }
        }
        .task {
            if planner == nil {
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
        }
        .environment(planner)
    }

    func requestItinerary() async throws {
        do {
            try await planner?.suggestItinerary()
        } catch {
            planner?.error = error
        }
    }
}
