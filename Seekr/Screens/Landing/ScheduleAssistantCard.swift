//
//  ScheduleAssistantCard.swift
//  Seekr
//
//  Created by Jishnu Raj  on 17/07/25.
//

import SwiftUI

struct ScheduleAssistantCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 36, height: 36)
                    Image(systemName: "calendar")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.blue)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("SCHEDULE ASSISTANT")
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(Color.blue)
                        .textCase(.uppercase)
                    Text("Your day has 2 hrs free before your next meeting")
                        .font(.callout)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity,alignment: .leading)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.gray.opacity(0.7))
            }
            HStack(spacing: 8) {
                Button(action: {}) {
                    Text("Plan a visit")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.12))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                }
                Button(action: {}) {
                    Text("View schedule")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.leading, 48)
        }
        .padding(16)
        .glassEffect(in: .rect(cornerSize: CGSize(width: 18, height: 18)))
        .padding(.horizontal)
    }
}
