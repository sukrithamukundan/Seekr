//
//  TripPlanningView.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//

import FoundationModels
import SwiftUI

struct TripPlanningView: View {
    let landmark: Landmark
    private let model = SystemLanguageModel.default

    var body: some View {
        switch model.availability {
        case .available:
            // Inject planner environment here if needed
            LandmarkTripView(landmark: landmark)
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
