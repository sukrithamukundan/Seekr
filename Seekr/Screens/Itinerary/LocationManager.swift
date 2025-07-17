//
//  LocationManager.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//

import Combine
import CoreLocation
import Foundation

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var userLandmark: Landmark?
    @Published var location: CLLocation?
    @Published var naturalLanguageQuery: String = ""

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last

        Task {
            if let coordinate = location?.coordinate {
                await getLocationName(from: coordinate)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }

    func getLocationName(from coordinate: CLLocationCoordinate2D) async {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                // You can customize what parts to include
                userLandmark = Landmark()
                userLandmark?.name = placemark.name ?? ""
                userLandmark?.description = placemark.locality ?? ""
                userLandmark?.continent = placemark.country ?? ""
                userLandmark?.latitude = coordinate.latitude
                userLandmark?.longitude = coordinate.longitude
                userLandmark?.naturalLanguageQuery = naturalLanguageQuery
            }
        } catch {
            print("Reverse geocoding failed: \(error.localizedDescription)")
        }
    }
}
