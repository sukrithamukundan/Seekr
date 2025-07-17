//
//  SeekrApp.swift
//  Seekr
//
//  Created by Sukritha K K on 15/07/25.
//

import SwiftUI

@main
struct SeekrApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            MainTabScreen()
        }
    }
}
