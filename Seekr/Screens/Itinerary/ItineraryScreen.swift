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
    @Environment(ItineraryPlanner.self) var planner: ItineraryPlanner?
    @EnvironmentObject var locationManager: LocationManager
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
    }

    func requestItinerary() async throws {
        do {
            try await planner?.suggestItinerary()
        } catch {
            planner?.error = error
        }
    }
}
