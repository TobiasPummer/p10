//
//  HealthManager.swift
//  TrialsOfTheEveryday
//
//  Created by Tobias Pummer on 20.09.24.
//
import SwiftUI
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay (for: Date())
    }
}
class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    @AppStorage("stamina") private var stamina: Int = 0
    @AppStorage("steps") private var CurrentStepCount: Double = 0
    
    @Published var stepCount: Double = 0.0
    @Published var caloriesCount: Double = 0.0
    @Published var totalSleepHours: Double = 0.0
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let sleep = HKCategoryType(.sleepAnalysis)
        let healthTypes: Set = [steps, calories, sleep]
        
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print("Error fetching HealthData")
            }
        }
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching today's step data")
                return
            }
            let steps = quantity.doubleValue(for: .count())
            
            let lastFetchDate = UserDefaults.standard.object(forKey: "LastFetchDate") as? Date ?? .startOfDay
            
            if !Calendar.current.isDateInToday(lastFetchDate) {
                DispatchQueue.main.async {
                    self.CurrentStepCount = 0
                }
            }
            
            UserDefaults.standard.set(Date(), forKey: "LastFetchDate")
            
            DispatchQueue.main.async {
                let addedSteps = max(0, steps - self.CurrentStepCount)
                let addedStamina = Int(addedSteps / 10)
                
                if addedStamina > 0 {
                    self.stamina += addedStamina
                }
                
                self.CurrentStepCount = steps
                self.stepCount = steps
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching today's calorie data")
                return
            }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            
            DispatchQueue.main.async {
                self.caloriesCount = caloriesBurned
            }
        }
        healthStore.execute(query)
    }
    
    func fetchTodaySleepHours() {
        let sleepType = HKCategoryType(.sleepAnalysis)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 0, sortDescriptors: nil) { _, samples, error in
            
            guard let samples = samples as? [HKCategorySample], error == nil else {
                print("Error fetching sleep data")
                return
            }
            
            var totalSleepTime: TimeInterval = 0
            
            for sample in samples {
                
                if sample.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue {
                    totalSleepTime += sample.endDate.timeIntervalSince(sample.startDate)
                }
            }
            
            let totalHoursSlept = totalSleepTime / 3600.0
            
            DispatchQueue.main.async {
                self.totalSleepHours = totalHoursSlept
            }
        }
        
        healthStore.execute(query)
    }
}
