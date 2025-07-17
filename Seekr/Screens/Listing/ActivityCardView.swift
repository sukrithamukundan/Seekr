//
//  ActivityCardView.swift
//  Seekr
//
//  Created by Sukritha K K on 17/07/25.
//

import SwiftUI
struct ActivityCardView: View {
    let activity: Activity.PartiallyGenerated

    var body: some View {
        NavigationLink {
            ActivityDetailView(activity: activity)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    AsyncImage(url: URL(string: activity.image ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipped()
                            .cornerRadius(12)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                            .frame(width: 70, height: 70)
                            .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            if let title = activity.title {
                                Text(title)
                                    .font(.headline)
                                    .foregroundStyle(Color.white)
                            }
                            Spacer()
                            Image(systemName: "bookmark")
                                .foregroundStyle(.gray)
                        }

                        HStack(spacing: 4) {
                            if let rating = activity.rating {
                                ForEach(0 ..< 5) { i in
                                    Image(systemName: i < Int(rating) ? "star.fill" : "star")
                                        .font(.caption)
                                        .foregroundStyle(.yellow)
                                }
                                Text(String(format: "%.1f", rating))
                                    .font(.subheadline)
                                    .foregroundStyle(Color.white)
                            }

                            if let reviews = activity.reviews {
                                Text("(\(reviews))")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }

                        if let location = activity.location, !location.isEmpty {
                            Text(location)
                                .font(.subheadline)
                                .foregroundStyle(Color.gray)
                                .lineLimit(2)
                        }

                        HStack(spacing: 16) {
                            if let walkTime = activity.walkTime, walkTime > 0 {
                                Label("\(walkTime) min", systemImage: "figure.walk")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            } else if let distance = activity.distance, distance > 0 {
                                Label("\(distance / 1000) km", systemImage: "location.fill")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            if let noiseLevel = activity.noiseLevel {
                                Label(noiseLevel, systemImage: "speaker.wave.2")
                                    .font(.caption)
                                    .foregroundStyle(Color.white)
                            }
                            if let amenities = activity.amenities, !amenities.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(amenities, id: \.self) { amenity in
                                            Text(amenity)
                                                .font(.caption)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 4)
                                                .background(Color.blue.opacity(0.1))
                                                .foregroundStyle(.blue)
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                            if let isOpen = activity.isOpenNow {
                                Text(isOpen ? "Open" : "Closed")
                                    .font(.caption)
                                    .foregroundStyle(isOpen ? .green : .red)
                            }
                        }
                    }
                }
                .background(Color(.systemGray6))
                .cornerRadius(16)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
