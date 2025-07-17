//
//  HealthManager.swift
//  Seekr
//
//  Created by Jishnu Raj  on 17/07/25.
//


import HealthKit
internal import Combine
class HealthManager: ObservableObject {
    private var healthStore = HKHealthStore()
    @Published var stepCount: Double = 12000
    init() {
        requestAuthorization()
    }
    func requestAuthorization() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, error in
            if success {
                self.fetchSteps()
            }
        }
    }
    func fetchSteps() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let now = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                if let quantity = result?.sumQuantity() {
                    self.stepCount = quantity.doubleValue(for: .count())
                }
            }
        }
        healthStore.execute(query)
    }
}
