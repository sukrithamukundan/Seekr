//
//  LandmarkTripView.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//

import FoundationModels
import MapKit
import SwiftUI
import WeatherKit

public struct LandmarkTripView: View {
    @State private var requestedItinerary: Bool = false
    @Environment(ItineraryPlanner.self) var planner: ItineraryPlanner?

    let landmark: Landmark

    public var body: some View {
        if let error = planner?.error {
            MessageView(error: error, landmark: landmark)
        } else {
            ScrollView {
                if let itinerary = planner?.itinerary {
                    ItineraryView(landmark: landmark, itinerary: itinerary)
                        .padding()
                } else if let planner {
                    ItineraryPlanningView(landmark: landmark, planner: planner)
                }
            }
            .scrollDisabled(!requestedItinerary)
        }
    }
}
