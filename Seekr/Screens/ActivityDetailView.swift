//
//  ActivityDetailView.swift
//  Seekr
//
//  Created by Sukritha K K on 17/07/25.
//

import CoreLocation
import MapKit
import SwiftUI
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
                    ActivityLocationMap(locationName: location, title: activity.title)
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
                            NavigationLink {
                                WebView(url: URL(string: website)!)
                            } label: {
                                Label("Website", systemImage: "safari")
                            }
                        }

                        if let phone = activity.phoneNumber {
                            Link(destination: URL(string: "tel:\(phone)")!) {
                                Label("Call", systemImage: "phone.fill")
                            }
                        }
                        if let url = activity.directionsURL, !url.isEmpty {
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
    @StateObject var viewModel: LocationViewModel
    let title: String
    init(locationName: String, title: String?) {
        _viewModel = StateObject(wrappedValue: LocationViewModel(locationName: locationName, title: title ?? ""))
        self.title = title ?? ""
    }

    var body: some View {
        Map(position: $viewModel.camera) {
            if let loc = viewModel.annotation {
                Marker(item: loc)
            }
        }
        .mapStyle(.hybrid)
        .frame(height: 280)
        .cornerRadius(20)
        .padding(.horizontal)
        .onAppear {
            viewModel.fetchCoordinates(for: viewModel.locationName, title: title)
        }
    }
}

internal import Combine

class LocationViewModel: ObservableObject {
    @Published var camera: MapCameraPosition
    @Published var locationName: String
    @Published var annotation: MKMapItem?

    init(locationName: String, title: String) {
        self.locationName = locationName
        camera = .userLocation(fallback: .automatic)
        fetchCoordinates(for: locationName,title: title)
    }

    func fetchCoordinates(for locationName: String, title: String) {
        // Use MKLocalSearch to geocode the location
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = locationName

        let search = MKLocalSearch(request: request)

        search.start { [weak self] response, error in
            if let error = error {
                print("Failed to geocode: \(error.localizedDescription)")
                return
            }

            // Get the first result
            guard let mapItem = response?.mapItems.first else {
                print("No matching results found.")
                return
            }

            // Get the coordinates from the map item

            self?.camera = MapCameraPosition.item(mapItem)

            // Set the annotation to the fetched coordinates
            self?.annotation = mapItem
            self?.annotation?.name = title
        }
    }
}
