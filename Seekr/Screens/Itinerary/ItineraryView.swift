//
//  ItineraryView.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//

import FoundationModels
import MapKit
import SwiftUI
import WeatherKit

struct ItineraryView: View {
    let landmark: Landmark
    let itinerary: DayPlan.PartiallyGenerated

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                if let title = itinerary.title {
                    Text(title)
                        .contentTransition(.opacity)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

//                if let description = itinerary.description {
//                    Text(description)
//                        .contentTransition(.opacity)
//                        .font(.subheadline)
//                        .foregroundStyle(.secondary)
//                }
            }
            if let rationale = itinerary.rationale {
                HStack(alignment: .top) {
                    Image(systemName: "sparkles")
                    Text(rationale)
                        .contentTransition(.opacity)
                }
                .rationaleStyle()
            }

            if let days = itinerary.activities {
                ForEach(days) { plan in
                    if let title = plan.title {
                        Text(title)
                    }
                }
            }
        }
        .animation(.easeOut, value: itinerary)
        .itineraryStyle()
    }
}
