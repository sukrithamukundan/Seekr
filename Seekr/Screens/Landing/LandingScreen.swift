//
//  LandingScreen.swift
//  Seekr
//
//  Created by Sukritha K K on 16/07/25.
//

import MapKit
import SwiftUI

struct LandingScreen: View {
    var body: some View {
        NavigationStack {
            Map(initialPosition: .userLocation(fallback: .region(.bangalore)))
        }
    }
}

#Preview {
    LandingScreen()
}
