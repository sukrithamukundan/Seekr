//
//  ModelData.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//


import Foundation
@preconcurrency import MapKit
import CoreLocation
import Synchronization

@Observable
class ModelData {
    @MainActor
    static let shared = ModelData()
    nonisolated static let landmarks: [Landmark] = parseLandmarks(fileName: "landmarkData.json")
    nonisolated static var landmarkNames: [String] {
        landmarks.map(\.name)
    }
    
    var landmarksByContinent: [String: [Landmark]] = [:]
    var featuredLandmark: Landmark?
    var landmarksByID: [Int: Landmark] = [:]
        
    private init() {
        loadLandmarks()
    }
    
    func loadLandmarks() {
        landmarksByContinent = landmarksByContinent(from: ModelData.landmarks)
        
        for landmark in ModelData.landmarks {
            landmarksByID[landmark.id] = landmark
        }

        if let primaryLandmark = landmarksByID[1016] {
            featuredLandmark = primaryLandmark
        }
    }
    
    private func landmarksByContinent(from landmarks: [Landmark]) -> [String: [Landmark]] {
        var landmarksByContinent: [String: [Landmark]] = [:]
        for landmark in landmarks {
            landmarksByContinent[landmark.continent, default: []].append(landmark)
        }
        return landmarksByContinent
    }
    
    static func parseLandmarks(fileName: String) -> [Landmark] {
        guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            fatalError("Couldn't find \(fileName) in main bundle.")
        }

        do {
            let data: Data = try Data(contentsOf: file)
            let decoder = JSONDecoder()
            return try decoder.decode([Landmark].self, from: data)
        } catch {
            fatalError("Couldn't parse \(fileName):\n\(error)")
        }
    }
}
