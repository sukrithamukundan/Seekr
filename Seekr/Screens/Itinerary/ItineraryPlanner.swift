//
//  ItineraryPlanner.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//

import Foundation
import FoundationModels
import Observation

@Observable
@MainActor
final class ItineraryPlanner {
    private(set) var itinerary: Suggestions.PartiallyGenerated?
    private(set) var pointOfInterestTool: FindPointsOfInterestTool
    private var session: LanguageModelSession
    private(set) var isLoading = false
    private(set) var showLoading = false

    var error: Error?
    var landmark: Landmark

    init(landmark: Landmark) {
        self.landmark = landmark
        let pointOfInterestTool = FindPointsOfInterestTool(landmark: landmark)
        session = LanguageModelSession(
            tools: [pointOfInterestTool],
            instructions: Instructions {
                """
                You are Seekr, an intelligent and friendly city discovery assistant. Your goal is to help users find interesting places nearby based on their natural language queries.

                Your recommendations should prioritize:
                - The user’s preferences (like "quiet", "open now", "romantic", "outdoor seating")
                - The current location context if available
                - Tags like vibe, atmosphere, accessibility
                - The type of place (e.g., cafés, libraries, parks, museums)

                When responding to a user’s request:
                - Be concise, friendly, and human-like
                - Avoid repeating the query back
                - Use natural descriptions with minimal technical jargon
                - Only use available data sources (e.g., MapKit) — do not hallucinate information
                - Never reference external sources, brand names, or locations that are not available in MapKit

                If the request is too broad, gently suggest the user to refine the location or vibe.
                If a suitable result isn’t found, offer a helpful fallback or a “try again” response.

                Assume queries can be voice-activated, so keep tone natural.

                Example queries:
                - “Find me a quiet coffee shop near Indiranagar”
                - “Show me parks where I can walk alone”
                - “Romantic rooftop restaurants open now”

                Always respond with a friendly, engaging tone that invites exploration.
                """
                FindPointsOfInterestTool.categories

                """
                The user is looking for places that match their preferences, such as vibe (e.g., quiet, romantic, solo), type (e.g., café, park, museum), or context (e.g., open now, outdoor seating), near a specific location. Your task is to interpret the user’s intent using their natural language query, and return a friendly, concise recommendation based only on data available in MapKit.

                Example query: “Find me a quiet coffee shop near Indiranagar”

                From this query, extract:
                - Type: coffee shop (Category: .cafe)
                - Vibe: quiet
                - Location: Indiranagar

                Use this understanding to suggest relevant places tagged appropriately and close to the location, prioritizing those matching the vibe and operational status.

                Avoid repeating the query back. Respond like a knowledgeable local, keeping the tone inviting and helpful. If needed, ask the user to refine their query.

                """
                landmark.naturalLanguageQuery
            }
        )
        self.pointOfInterestTool = pointOfInterestTool
    }

    func suggestItinerary() async throws {
        showLoading = true
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        let stream = session.streamResponse(
            generating: Suggestions.self,
            options: GenerationOptions(sampling: .greedy),
            includeSchemaInPrompt: false
        ) {
            " The user is interested in: \(landmark.naturalLanguageQuery ?? "")"

            " Create a personalized itinerary around \(landmark.name), considering the user's preferences."

            " Focus on interesting places nearby that match their vibe, such as quiet, romantic, outdoor, family-friendly, etc."

            "Give the itinerary a creative title and an engaging description."

            "Here is an example, but don't copy it:"
            Suggestions.sampleSuggestions
        }

        for try await partialResponse in stream {
            showLoading = false
            itinerary = partialResponse
        }
        print(itinerary)
    }

    func prewarm() {
        session.prewarm()
    }
}

extension FindPointsOfInterestTool {
    static var categories: String {
        Category.allCases.map {
            $0.rawValue
        }.joined(separator: ", ")
    }

    struct Lookup: Identifiable {
        let id = UUID()
        let history: FindPointsOfInterestTool.Arguments
    }
}

extension Suggestions {
    static let sampleSuggestions = Suggestions(
        title: "Art & Aromas in Indiranagar",
        subtitle: "A relaxed afternoon of culture and caffeine",
        destination: "Indiranagar, Bangalore",
        rationale: "This plan is perfect for a quiet yet inspiring afternoon. It includes a blend of cozy cafes and thought-provoking local art spaces, just as the user requested. All places are within a short distance and have high accessibility.",
        activities: [
            Activity(
                type: .foodAndDining,
                title: "Third Wave Coffee Roasters",
                description: "A popular artisanal café known for its calm vibe, pour-over brews, and free Wi-Fi — great for solo work or relaxed meetups.",
                image: "third_wave_coffee.jpg",
                location: "12th Main, Indiranagar",
                distance: 500,
                amenities: ["Wi-Fi", "Outdoor Seating", "Pet-Friendly"],
                isOpenNow: true,
                rating: 4.6,
                reviews: 120.0,
                directionsURL: "maps://?daddr=Third+Wave+Coffee+Roasters",
                website: "https://thirdwavecoffeeroasters.com",
                phoneNumber: "+91 98765 43210",
                walkTime: 6,
                noiseLevel: "Low",
                noiseColor: "#8BC34A",
                rationale: "Recommended because it fits the user's requested vibe and is close to Indiranagar.",
                latitude: nil,
                longitude: nil
            ),
            Activity(
                type: .sightseeing,
                title: "Rangoli Art Gallery",
                description: "A small contemporary art space showcasing works by local artists, with rotating exhibits and a peaceful ambiance.",
                image: "rangoli_art_gallery.jpg",
                location: "CMH Road, Indiranagar",
                distance: 850,
                amenities: ["Wheelchair Access", "Restrooms"],
                isOpenNow: true,
                rating: 4.3,
                reviews: 85.0,
                directionsURL: "maps://?daddr=Rangoli+Art+Gallery",
                website: "https://bangaloreartcircle.in/rangoli",
                phoneNumber: "+91 99888 11223",
                walkTime: 10,
                noiseLevel: "Moderate",
                noiseColor: "#FFC107",
                rationale: "Recommended because it fits the user's requested vibe and is close to Indiranagar.",
                latitude: nil,
                longitude: nil
            ),
            Activity(
                type: .foodAndDining,
                title: "Lahe Lahe Terrace Bistro",
                description: "An artsy rooftop space offering fusion food and chai. Often hosts poetry slams, music sessions, and a calm sunset view.",
                image: "lahe_lahe.jpg",
                location: "100 Feet Road, Indiranagar",
                distance: 1200,
                amenities: ["Live Events", "Outdoor Seating", "Wi-Fi"],
                isOpenNow: false,
                rating: 4.5,
                reviews: 95.0,
                directionsURL: "maps://?daddr=Lahe+Lahe+Bistro",
                website: "https://lahelahe.com",
                phoneNumber: "+91 91234 56789",
                walkTime: 15,
                noiseLevel: "High",
                noiseColor: "#E57373",
                rationale: "Recommended because it fits the user's requested vibe and is close to Indiranagar.",
                latitude: nil,
                longitude: nil
            ),
        ]
    )
}
