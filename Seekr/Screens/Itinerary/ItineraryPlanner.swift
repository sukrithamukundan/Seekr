//
//  ItineraryPlanner.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//

import FoundationModels
import Observation
import Foundation

@Observable
@MainActor
final class ItineraryPlanner {
    private(set) var itinerary: DayPlan.PartiallyGenerated?
    private(set) var pointOfInterestTool: FindPointsOfInterestTool
    private var session: LanguageModelSession

    var error: Error?
    let landmark: Landmark

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
                Here is a description of \(landmark.name) for your reference \
                when considering what activities to generate:
                """
                landmark.description
            }
        )
        self.pointOfInterestTool = pointOfInterestTool
    }

    func suggestItinerary() async throws {
        let stream = session.streamResponse(
            generating: DayPlan.self,
            options: GenerationOptions(sampling: .greedy),
            includeSchemaInPrompt: false
        ) {
            "Find interesting places nearby \(landmark.name)."

            "Give it a fun title and description."

            "Here is an example, but don't copy it:"
            DayPlan.exampleDayInKawaguchiko
        }

        for try await partialResponse in stream {
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

extension DayPlan {
    static let exampleDayInKawaguchiko = DayPlan(
        title: "Sushi and Shopping Near Kawaguchiko",
        subtitle: "Spend your final day enjoying sushi and souvenir shopping.",
        destination: "Kawaguchiko Lake",
        rationale: "This day plan highlights the best local sushi and shopping options to provide a memorable final day experience based on user interest in food and unique souvenirs.",
        activities: [
            Activity(
                type: .foodAndDining,
                title: "The Restaurant serving Sushi",
                description: "Visit an authentic sushi restaurant for lunch.",
                image: nil,
                location: "",
                distance: 0,
                amenities: [],
                isOpenNow: false,
                rating: nil,
                directionsURL: nil,
                website: nil,
                phoneNumber: nil
            ),
            Activity(
                type: .shopping,
                title: "The Plaza",
                description: "Enjoy souvenir shopping at various shops.",
                image: nil,
                location: "",
                distance: 0,
                amenities: [],
                isOpenNow: false,
                rating: nil,
                directionsURL: nil,
                website: nil,
                phoneNumber: nil
            ),
            Activity(
                type: .sightseeing,
                title: "The Beautiful Cherry Blossom Park",
                description: "Admire the beautiful cherry blossom trees in the park.",
                image: nil,
                location: "",
                distance: 0,
                amenities: [],
                isOpenNow: false,
                rating: nil,
                directionsURL: nil,
                website: nil,
                phoneNumber: nil
            ),
        ]
    )
}
