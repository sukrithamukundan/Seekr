//
//  Itinerary.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//

import Foundation
import FoundationModels
//
// @Generable
// struct Itinerary: Equatable {
//    @Guide(description: "An exciting name for the trip.")
//    let title: String
//    @Guide(.anyOf(ModelData.landmarkNames))
//    let destinationName: String
//    let description: String
//    @Guide(description: "An explanation of how the itinerary meets the user's special requests.")
//    let rationale: String
//
//    @Guide(description: "A list of day-by-day plans.")
//    @Guide(.count(3))
//    let days: [DayPlan]
// }

@Generable
struct DayPlan: Equatable {
    @Guide(description: "A unique and exciting title for this day plan.")
    let title: String
    let subtitle: String
    let destination: String
    @Guide(description: "An explanation of how the itinerary meets the user's special requests.")
    let rationale: String

    @Guide(.count(3))
    let activities: [Activity]
}

@Generable
struct Activity: Equatable {

    @Guide(description: "The high-level classification of this activity, such as sightseeing, food and dining, or shopping.")
    let type: Kind

    @Guide(description: "A short, user-facing name of the place or activity, such as 'Lahe Lahe Café'.")
    let title: String

    @Guide(description: "A brief, informative summary of the activity — ideal for use in detail pages or list previews.")
    let description: String

    @Guide(description: "A URL or asset name pointing to an image that visually represents the activity or location.")
    let image: String?

    @Guide(description: "The human-readable address or neighborhood of the activity’s location.")
    let location: String

    @Guide(description: "The distance of this activity from the user’s current location, typically in meters or kilometers.")
    let distance: Int

    @Guide(description: "A list of available amenities like Wi-Fi, pet-friendly, wheelchair access, or parking.")
    let amenities: [String]

    @Guide(description: "A Boolean flag indicating whether the place is currently open or closed.")
    let isOpenNow: Bool

    @Guide(description: "A numeric rating of the activity (typically between 0 and 5), based on reviews or user feedback.")
    let rating: Double?

    @Guide(description: "A deep link or map URL that provides directions to the activity from the user’s location.")
    let directionsURL: String?

    @Guide(description: "The official website of the location or activity, if available.")
    let website: String?

    @Guide(description: "The contact phone number associated with the activity or location.")
    let phoneNumber: String?
}


@Generable
enum Kind {
    case sightseeing // Museums, monuments, landmarks
    case foodAndDining // Cafés, restaurants, wineries
    case shopping // Boutiques, local markets, stores

    case natureAndOutdoors // Parks, beaches, trails, national parks
    case cultureAndHistory // Castles, fortresses, cultural centers
    case relaxation // Spas, quiet cafés, nature spots
    case eventsAndEntertainment // Live music, fairs, open mics, theaters
    case accommodation // Hotels, campgrounds, RV parks
    case wellness // Yoga studios, wellness cafés, walkable areas
    case nightlife // Breweries, bars, rooftops, clubs
    case withKids // Zoos, planetariums, family-friendly
    case hiddenGems // AI-tagged quirky/offbeat places
}

//import FoundationModels
//
//extension URL: ConvertibleFromGeneratedContent, ConvertibleToGeneratedContent, Generable {
//    public init(fromGeneratedContent value: any GeneratedContentValue) throws {
//        let urlString = try String(fromGeneratedContent: value)
//        guard let url = URL(string: urlString) else {
//            throw NSError(domain: "Invalid URL string", code: 1, userInfo: ["string": urlString])
//        }
//        self = url
//    }
//
//    public func toGeneratedContentValue() throws -> GeneratedContentValue {
//        return self.absoluteString
//    }
//}
