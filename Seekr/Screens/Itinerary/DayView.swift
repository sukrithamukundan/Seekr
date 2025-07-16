//
//  DayView.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//

import SwiftUI

//private struct DayView: View {
//    let landmark: Landmark
//    let plan: DayPlan.PartiallyGenerated
//
//    @State private var map = LocationLookup()
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            ZStack(alignment: .bottom) {
//                LandmarkDetailMapView(
//                    landmark: landmark,
//                    landmarkMapItem: map.item
//                )
//                .onChange(of: plan.destination) { _, newValue in
//                    if let destination = newValue {
//                        map.performLookup(location: destination)
//                    }
//                }
//                
//                VStack(alignment: .leading) {
//                    Text(weatherForecast)
//                        .font(.subheadline)
//                        .foregroundStyle(.secondary)
//                    if let title = plan.title {
//                        Text(title)
//                            .contentTransition(.opacity)
//                            .font(.headline)
//                    }
//                    if let subtitle = plan.subtitle {
//                        Text(subtitle)
//                            .contentTransition(.opacity)
//                            .font(.subheadline)
//                            .foregroundStyle(.secondary)
//                    }
//                }
//                .padding(12)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .blurredBackground()
//            }
//            .clipShape(RoundedRectangle(cornerRadius: 12))
//            .frame(maxWidth: .infinity)
//            .frame(height: 200)
//            .padding([.horizontal, .top], 4)
//            
//            ActivityList(activities: plan.activities ?? [])
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal)
//        }
//        .padding(.bottom)
//        .geometryGroup()
//        .card()
//        .animation(.easeInOut, value: plan)
//    }
//    
//    var weatherForecast: LocalizedStringKey {
//        if let forecast = map.temperatureString {
//            "\(Image(systemName: "cloud.fill")) \(forecast)"
//        } else {
//            " "
//        }
//    }
//}
