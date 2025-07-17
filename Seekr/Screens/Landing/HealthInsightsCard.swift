//
//  HealthInsightsCard.swift
//  Seekr
//
//  Created by Jishnu Raj  on 17/07/25.
//

import SwiftUI

struct HealthInsightsCard: View {
    @StateObject private var healthManager = HealthManager()
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.17))
                        .frame(width: 36, height: 36)
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.green)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("HEALTH INSIGHTS")
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(Color.green)
                        .textCase(.uppercase)
                    Text("You've walked \(healthManager.stepCount.formatted(.number.notation(.compactName))) steps today")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.gray.opacity(0.7))
            }
            if healthManager.stepCount < 4000 {
                Text("Need a break? Explore quiet parks or cafés nearby 🍃")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 48)
            } else {
                Text("You've been active! Check out trending spots or walkable events nearby 🚶‍♀️")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 48)
            }
        }
        .padding(16)
        .glassEffect(in: .rect(cornerSize: CGSize(width: 18, height: 18)))
        .padding(.horizontal)
    }
}

#Preview {
    HealthInsightsCard()
}
