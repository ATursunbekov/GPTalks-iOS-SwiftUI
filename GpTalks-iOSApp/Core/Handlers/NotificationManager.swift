//
//  NotificationHandler.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 28/8/23.
//
//

import SwiftUI
import UserNotifications
import CoreLocation

class NotificationManager {
    
    static let shared = NotificationManager() // Singleton
    
    private init() {}
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    // this is where I call up the discount notifications
    func daysNotifications() {
        scheduleNotification(after: 0, withText: "We have a special offer for you with a 40% discount for the PRO version")
        scheduleNotification(after: 2, withText: "Awesome price for your AI personal assistant! 60% discount for the PRO version")
        scheduleNotification(after: 4, withText: "We have a special offer for you with a 40% discount for the PRO version")
        scheduleNotification(after: 6, withText: "Awesome price for your AI personal assistant! 60% discount for the PRO version")
        let lastLoginDate = Date() // Здесь нужно использовать дату последнего входа пользователя
        
        // Вычисляем разницу в днях между текущей датой и датой последнего входа
        let calendar = Calendar.current
        if let daysSinceLastLogin = calendar.dateComponents([.day], from: lastLoginDate, to: Date()).day {
            if daysSinceLastLogin >= 3 && daysSinceLastLogin <= 9 {
                // Отправляем уведомление через 3, 6 или 9 дней после последнего входа
                scheduleNotification(after: daysSinceLastLogin, withText: "Сообщение о скидке")
            }
        }
    }
    
    // creating scheduled notifications
    func scheduleNotification(after days: Int, withText text: String) {
        let content = UNMutableNotificationContent()
        content.title = "Discount Offer"
        content.body = text
        
        let currentDate = Date()
        if let date = Calendar.current.date(byAdding: .day, value: days, to: currentDate) {
            let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully")
                }
            }
        } else {
            print("Error creating trigger date")
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
