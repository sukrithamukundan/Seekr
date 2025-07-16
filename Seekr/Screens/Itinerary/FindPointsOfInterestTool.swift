//
//  FindPointsOfInterestTool.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//

import FoundationModels
import SwiftUI

@Observable
final class FindPointsOfInterestTool: Tool {
    let name = "findPointsOfInterest"
    let description = "Finds points of interest for a landmark."

    let landmark: Landmark

    @MainActor var lookupHistory: [Lookup] = []

    init(landmark: Landmark) {
        self.landmark = landmark
    }

    @Generable
    enum Category: String, CaseIterable {
        // Places to eat, drink, and be merry.
        case bakery
        case brewery
        case cafe
        case distillery
        case restaurant
        case winery

        // Places to stay.
        case campground
        case hotel
        case rvPark

        // Places to go.
        case beach
        case castle
        case conventionCenter
        case fairground
        case fortress
        case nationalMonument
        case nationalPark
        case planetarium
        case spa
        case zoo
    }

    @Generable
    struct Arguments {
        @Guide(description: "This is the type of destination to look up for.")
        let pointOfInterest: Category

        @Guide(description: "The natural language query of what to search for.")
        let naturalLanguageQuery: String
    }

    @MainActor func recordLookup(arguments: Arguments) {
        lookupHistory.append(Lookup(history: arguments))
    }

    func call(arguments: Arguments) async throws -> ToolOutput {
        // This sample app pulls some static data. Real-world apps can get creative.
        await recordLookup(arguments: arguments)
        let results = mapItems(arguments: arguments)
        return ToolOutput(
            "There are these \(arguments.pointOfInterest) in \(landmark.name): \(results.joined(separator: ", "))"
        )
    }

    private func mapItems(arguments: Arguments) -> [String] {
        suggestions(category: arguments.pointOfInterest)
    }
}

extension FindPointsOfInterestTool {
    func suggestions(category: Category) -> [String] {
        switch category {
        // 🍰 Eat, Drink & Be Merry
        case .bakery:
            return ["Flour & Co", "Sweet Bloom", "The Bread House"]
        case .brewery:
            return ["Hop Valley Brewery", "Malt & Barrel", "Golden Tap House"]
        case .cafe:
            return ["Lahe Lahe Café", "Quiet Grounds", "Caffeine Alley"]
        case .distillery:
            return ["Spirit Works", "Copper Still", "Heritage Distillery"]
        case .restaurant:
            return ["The Gourmet Hub", "Sunset Grill", "Fork & Flame"]
        case .winery:
            return ["VinoVista Estate", "Crimson Vineyards", "Oak Cellars"]

        // 🛌 Places to Stay
        case .campground:
            return ["Hilltop Campground", "Whispering Pines", "Sunset Trails"]
        case .hotel:
            return ["Urban Nest Hotel", "The Cityscape", "Royal Suites"]
        case .rvPark:
            return ["Rolling Wheels RV Park", "Park & Chill", "RV Retreat"]

        // 🗺️ Places to Go
        case .beach:
            return ["Silver Sands Beach", "Calm Shoreline", "Golden Bay"]
        case .castle:
            return ["Stonehold Castle", "Ravensburg Fortress", "Crescent Keep"]
        case .conventionCenter:
            return ["Unity Convention Hall", "TechSpire Center", "Nexus Dome"]
        case .fairground:
            return ["Dreamscape Fair", "Neon Nights Park", "Festiville Grounds"]
        case .fortress:
            return ["Old Watchtower", "Ironclad Fortress", "Highwall Keep"]
        case .nationalMonument:
            return ["The National Rock", "Liberty Flame", "Heritage Pillar"]
        case .nationalPark:
            return ["Whispering Woods", "Valley Ridge Park", "Serenity Reserve"]
        case .planetarium:
            return ["Galaxy Dome", "Starview Planetarium", "Cosmos Hall"]
        case .spa:
            return ["Tranquil Springs", "Bliss Wellness Spa", "Zen Retreat"]
        case .zoo:
            return ["Rainforest Zoo", "Urban Wild Reserve", "Safari Park"]
        }
    }
}
