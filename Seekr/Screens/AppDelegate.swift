//
//  AppDelegate.swift
//  Seekr
//
//  Created by Sukritha K K on 17/07/25.
//


import UIKit
import Apptics // Import the Apptics SDK

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // This method is called when your app launches.
        // This is the perfect place to initialize Zoho Apptics.

        // Optional: Configure Apptics BEFORE initialization
        // If you want to disable automatic screen tracking (recommended for MVVM/custom screen names),
        // set this to false. Keep true if you want Apptics to try to track UIViewController appearances.
        // AppticsConfig.default.enableAutomaticScreenTracking = false

        // Apptics Initialization
        // Set withVerbose: true during development for detailed console logs.
        // Set to false for production to minimize logging.
        Apptics.initialize(withVerbose: true)

        // If you've integrated AppticsMessaging for Push Notifications, start its service here:
        // AppticsMessaging.startService()

        print("Apptics Initialized in AppDelegate!") // For debugging confirmation

        return true
    }

    // You can add other AppDelegate methods here if needed by other SDKs or for specific app lifecycle events.
    // For example, for handling push notifications, deep links, etc.
}