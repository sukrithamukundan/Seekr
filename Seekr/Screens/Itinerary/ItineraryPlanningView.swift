//
//  ItineraryPlanningView.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//



import SwiftUI

struct ItineraryPlanningView: View {
    let landmark: Landmark
    let planner: ItineraryPlanner
    @State private var show = false
    
    var body: some View {
        VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Image(systemName: "sparkles")
                    Text("Planning itinerary for \(landmark.name)...")
                        .opacity(show ? 1 : 0)
                }
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
            
            ForEach(planner.pointOfInterestTool.lookupHistory) { element in
                HStack {
                    Image(systemName: "location.magnifyingglass")
                    Text("Searching **\(element.history.pointOfInterest.rawValue)** in \(landmark.name)...")
                }
                .transition(.blurReplace)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding()
            .card()
        }
        .animation(.default, value: planner.pointOfInterestTool.lookupHistory.count)
        .symbolEffect(.breathe, isActive: true)
        .padding()
        .padding(.top, 120)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            show = true
        }
    }
}