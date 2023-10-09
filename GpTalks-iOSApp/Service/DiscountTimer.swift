//
//  DiscountTimer.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 1/9/23.
//

import Foundation
import Combine
import UserNotifications

class DiscountTimer: ObservableObject {
    @Published var timeUntilNextDiscount: TimeInterval = 0
    @Published var currentDiscountPercentage: Int = 0
    @Published var discountPattern: [(Int, Int)] = [(2, 40), (2, 60), (2, 40), (-1, 60)]
    @Published var infinityDiscount: Bool = false
    
    private var currentDiscountIndex = 0
    private var timer: DispatchSourceTimer?
    private var nextDiscountDate: Date?
    private var hasFetchedServerTime = false
    
    init() {
        if let savedTime = UserDefaults.standard.object(forKey: "SavedTimeUntilNextDiscount") as? Date {
            nextDiscountDate = savedTime
        } else {
            fetchNextDiscountDateFromServer()
        }
        
        if let savedPattern = UserDefaults.standard.array(forKey: "DiscountPattern") as? [(Int, Int)] {
            discountPattern = savedPattern
        }
        if let savedIndex = UserDefaults.standard.value(forKey: "CurrentDiscountIndex") as? Int {
            currentDiscountIndex = savedIndex
        }
        
        setCurrentDiscountPercentage()
        
        updateTimeUntilNextDiscount()
        startTimer()
    }
    
    func setCurrentDiscountPercentage() {
        if currentDiscountIndex < discountPattern.count {
            let (_, percentage) = discountPattern[currentDiscountIndex]
            currentDiscountPercentage = percentage
        } else {
            currentDiscountPercentage = 60
        }
        
        UserDefaults.standard.set(currentDiscountIndex, forKey: "CurrentDiscountIndex")
        UserDefaults.standard.synchronize()
    }
    
    private func fetchNextDiscountDateFromServer() {
        ServerTimeProvider.shared.fetchServerTime { [weak self] serverTime in
            if let serverTime = serverTime {
                let calendar = Calendar.current
                if serverTime < Date() {
                    self?.nextDiscountDate = calendar.date(byAdding: .day, value: 2, to: Date())
                } else {
                    self?.nextDiscountDate = serverTime
                }
                
                UserDefaults.standard.set(self?.nextDiscountDate, forKey: "SavedTimeUntilNextDiscount")
                UserDefaults.standard.synchronize()
                
                DispatchQueue.main.async {
                    self?.currentDiscountPercentage = self?.calculateCurrentDiscountPercentage() ?? 0
                }
                self?.startTimer()
            } else {
                print("Error fetching server time")
            }
        }
    }
    
    
    func applicationWillTerminate() {
        UserDefaults.standard.set(nextDiscountDate, forKey: "SavedTimeUntilNextDiscount")
        UserDefaults.standard.synchronize()
    }
    
    func startTimer() {
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        timer?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.updateTimeUntilNextDiscount()
            }
        }
        timer?.resume()
    }
    
    func updateTimeUntilNextDiscount() {
        guard let nextDate = nextDiscountDate else {
                return
            }
            
            if hasFetchedServerTime {
                if timeUntilNextDiscount <= 0 {
                    currentDiscountIndex += 1
                    
                    if currentDiscountIndex < discountPattern.count {
                        let (days, percentage) = discountPattern[currentDiscountIndex]
                        
                        if days == -1 {
                            currentDiscountPercentage = percentage
                        } else {
                            let calendar = Calendar.current
                            nextDiscountDate = calendar.date(byAdding: .day, value: days, to: nextDate)
                            DispatchQueue.main.async {
                                self.currentDiscountPercentage = percentage
                            }
                        }
                        
                        UserDefaults.standard.set(currentDiscountIndex, forKey: "CurrentDiscountIndex")
                        UserDefaults.standard.set(nextDiscountDate, forKey: "SavedTimeUntilNextDiscount")
                        UserDefaults.standard.synchronize()
                        
                        DispatchQueue.main.async {
                            self.timeUntilNextDiscount = TimeInterval(days * 60)
                        }
                        
                        startTimer()
                    } else {
                        DispatchQueue.main.async {
                            self.currentDiscountPercentage = 60
                        }
                       
                    }
                } else {
                    timeUntilNextDiscount -= 1
                }
            } else {
            ServerTimeProvider.shared.fetchServerTime { [weak self] serverTime in
                if let serverTime = serverTime {
                    let calendar = Calendar.current
                    
                    let elapsedTime = nextDate.timeIntervalSince(serverTime)
                    
                    if elapsedTime > 0 {
                        DispatchQueue.main.async {
                            self?.timeUntilNextDiscount = elapsedTime
                        }
                    } else {
                        let nextPatternIndex = self?.currentDiscountIndex ?? 0 + 1
                        
                        if nextPatternIndex < self?.discountPattern.count ?? 0 {
                            let (days, percentage) = self?.discountPattern[nextPatternIndex] ?? (0, 0)
                            
                            if days == -1 {
                                DispatchQueue.main.async {
                                    self?.currentDiscountPercentage = percentage
                                }
                            } else {
                                self?.nextDiscountDate = calendar.date(byAdding: .day, value: days, to: serverTime)
                                DispatchQueue.main.async {
                                    self?.currentDiscountPercentage = percentage
                                }
                            }
                            
                            UserDefaults.standard.set(self?.currentDiscountIndex, forKey: "CurrentDiscountIndex")
                            UserDefaults.standard.set(self?.nextDiscountDate, forKey: "SavedTimeUntilNextDiscount")
                            UserDefaults.standard.synchronize()
                            
                            self?.updateTimeUntilNextDiscount()
                        } else {
                            DispatchQueue.main.async {
                                self?.currentDiscountPercentage = 60
                            }
                        }
                    }
                    
                    self?.hasFetchedServerTime = true
                } else {
                    print("Error fetching server time")
                }
            }
        }
    }

    
    func calculateCurrentDiscountPercentage() -> Int {
        let currentDate = Date()
        
        let futureDiscounts = discountPattern.filter { (days, _) in
            guard days != -1 else { return false }
            return days >= 0
        }
        
        let sortedDiscounts = futureDiscounts.sorted { $0.0 < $1.0 }
        
        for (days, percentage) in sortedDiscounts {
            if let startDate = Calendar.current.date(byAdding: .day, value: days, to: currentDate) {
                if startDate > currentDate {
                    return percentage
                }
            }
        }
        
        if let infiniteDiscount = discountPattern.first(where: { $0.0 == -1 }) {
            infinityDiscount = true
            return infiniteDiscount.1
        }
        
        return 0
    }
}
