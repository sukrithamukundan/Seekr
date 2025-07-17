//
//  ActivityDetailView.swift
//  Seekr
//
//  Created by Sukritha K K on 17/07/25.
//

import SwiftUI
import MapKit
import CoreLocation
import UIKit

struct ActivityDetailView: View {
    let activity: Activity.PartiallyGenerated
    @State private var isImageURLOpenable: Bool = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let image = activity.image, let url = URL(string: image), isImageURLOpenable {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 280)
                            .clipped()
                            .cornerRadius(20)

                            .padding(.horizontal)
                    } placeholder: {
                        Color.gray.opacity(0.2)
                            .frame(height: 280)
                            .cornerRadius(20)
                            .padding(.horizontal)
                    }

                } else if let location = activity.location, !location.isEmpty {
                    ActivityLocationMap(location: location)
                }
                VStack(alignment: .leading, spacing: 12) {
                    if let title = activity.title {
                        Text(title)
                            .font(.largeTitle.bold())
                    }

                    if let rationale = activity.rationale {
                        HStack(alignment: .top) {
                            Image(systemName: "sparkles")
                            Text(rationale)
                                .contentTransition(.opacity)
                        }
                        .rationaleStyle()
                    }

                    if let description = activity.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        if let isOpenNow = activity.isOpenNow {
                            Label(isOpenNow ? "Open Now" : "Closed", systemImage: isOpenNow ? "clock.badge.checkmark" : "clock.badge.xmark")
                                .foregroundColor(isOpenNow ? .green : .red)
                        }
                        Spacer()
                        if let rating = activity.rating {
                            Label(String(format: "%.1f", rating), systemImage: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    .font(.callout)
                    if let location = activity.location {
                        Label(location, systemImage: "mappin.and.ellipse")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }

                    if let amenities = activity.amenities,!amenities.isEmpty {
                        Text("Amenities")
                            .font(.headline)
                        ForEach(amenities, id: \.self) { amenity in
                            Label(amenity, systemImage: "checkmark.circle")
                                .font(.subheadline)
                        }
                    }

                    HStack {
                        if let website = activity.website {
                            Link(destination: URL(string: website)!) {
                                Label("Website", systemImage: "safari")
                            }
                        }
                        if let phone = activity.phoneNumber {
                            Link(destination: URL(string: "tel:\(phone)")!) {
                                Label("Call", systemImage: "phone.fill")
                            }
                        }
                        if let url = activity.directionsURL {
                            Link(destination: URL(string: url)!) {
                                Label("Directions", systemImage: "map")
                            }
                        }
                    }
                    .font(.callout)
                    .padding(.top, 8)
                }
                .padding(.horizontal)
            }
            .padding(.top)
            .task {
                if let image = activity.image, let url = URL(string: image) {
                    isImageURLOpenable = UIApplication.shared.canOpenURL(url)
                }
            }
        }
        .navigationTitle(activity.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ActivityLocationMap: View {
    let location: String?
    @State private var region: MKCoordinateRegion = .applePark
    @State private var coordinate: CLLocationCoordinate2D?
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: coordinate.map { [ActivityAnnotation(coordinate: $0)] } ?? []) { item in
            MapMarker(coordinate: item.coordinate, tint: .blue)
        }
        .frame(height: 280)
        .cornerRadius(20)
        .padding(.horizontal)
        .task {
            await lookupCoordinate()
        }
    }
    
    func lookupCoordinate() async {
        guard let location = location, !location.isEmpty else { return }
        do {
            let placemarks = try await CLGeocoder().geocodeAddressString(location)
            if let placemark = placemarks.first, let coord = placemark.location?.coordinate {
                await MainActor.run {
                    region = MKCoordinateRegion(center: coord, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    coordinate = coord
                }
            }
        } catch {
            // Leave fallback region
        }
    }
    struct ActivityAnnotation: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
}

