//
//  gptalks_ios_appApp.swift
//  gptalks-ios-app
//
//  Created by Aidar Asanakunov on 16/6/23.
//

import SwiftUI
import FirebaseCore
import Adapty
import BackgroundTasks
import CloudKit
import FirebaseAuth
import FirebaseFirestore
import UserNotifications
import AmplitudeSwift
import AppsFlyerLib
import AppTrackingTransparency

@main
struct GpTalks_iOSApp: App {
    @StateObject private var userSettings: UserSettings
    @StateObject private var chatViewModel = ChatViewModel()
    @StateObject private var categoryViewModel = CategoryViewModel()
    @StateObject private var purchaseViewModel = PurchaseViewModel()
    @StateObject private var discountTimer = DiscountTimer()
    @AppStorage("showOnboarding") var showOnboarding = true
    @AppStorage("showPayWall") var showPayWall = true
    @AppStorage("showRegistration") var  showReg = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        let userSettings = UserSettings()
        self._userSettings = StateObject(wrappedValue: userSettings)
        if userSettings.uid == nil {
            userSettings.uid = userSettings.generateUID()
        }
        print("New UID generated: \(String(describing: userSettings.uid))")
        Adapty.getProfile { result in
            if let profile = try? result.get(),
               profile.accessLevels["premium"]?.isActive ?? false {
                print(profile)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            
            Group {
                if showOnboarding {
                    OnboardingView(showOnBoarding: $showOnboarding)
                } else if showPayWall {
                    PayWall(showPayWall: $showPayWall)
                        .environmentObject(discountTimer)
                        .environmentObject(purchaseViewModel)
                } else if !showOnboarding && !showPayWall {
                    MainTabView()
                        .environmentObject(userSettings)
                        .environmentObject(chatViewModel)
                        .environmentObject(categoryViewModel)
                        .environmentObject(discountTimer)
                        .environmentObject(purchaseViewModel)
                        .onAppear {
                            purchaseViewModel.loadSubscriptionData()
                        }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                            switch status {
                            case .authorized:
                                AppsFlyerLib.shared().appsFlyerDevKey = "s4qMo6ZoAqGsmfY7U2n8t7"
                                AppsFlyerLib.shared().appleAppID = "6453692555"
                                AppsFlyerLib.shared().isDebug = true
                                AppsFlyerLib.shared().start()
                                print("Authorized")
                            case .denied:
                                // Tracking authorization dialog was
                                // shown and permission is denied
                                print("Denied")
                            case .notDetermined:
                                // Tracking authorization dialog has not been shown
                                print("Not Determined")
                            case .restricted:
                                print("Restricted")
                            @unknown default:
                                print("Unknown")
                            }
                        })
            }
            .onAppear {
                if !showReg {
                    CKContainer(identifier: "iCloud.com.deveem.gptalks-ios-app").fetchUserRecordID(completionHandler: { (recordId, error) in
                        if let name = recordId?.recordName {
                            print("iCloud ID: " + name)
                            Authantication.signIn(email: "\(name)@gmail.com", password: name) {
                                userSettings.refreshData()
                                chatViewModel.refreshData()
                                categoryViewModel.refreshData()
                            }
                        }
                        else if let error = error {
                            print(error.localizedDescription)
                        }
                    })
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    var discountTimer: DiscountTimer?
    let notificationCenter = UNUserNotificationCenter.current()
    
    func applicationWillTerminate(_ application: UIApplication) {
        discountTimer?.applicationWillTerminate()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                if #available(iOS 14, *) {
//                    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
//                        self.requestIDFA()
//                    })
//                } else {
//                }
//            }
        
//        AppsFlyerLib.shared().start(completionHandler: { (dictionary, error) in
//            if (error != nil){
//                print(error ?? "AppsFlyEr")
//                return
//            } else {
//                print(dictionary ?? "AppsFly")
//                return
//            }
//        })
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Adapty.activate("public_live_Lol3Jldd.WNK0egiCfygRDvdiSOGt", customerUserId: nil)
        FirebaseApp.configure()
        AmplitudeManager.shared.logFirstLogin()
        
        notificationCenter.delegate = self
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.scheduleLocalNotifications()
            } else {
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        scheduleBackgroundTask()
    }
    
    func scheduleBackgroundTask() {
        let task = BGAppRefreshTaskRequest(identifier: "com.example.discounttimer.backgroundtask")
        task.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
            try BGTaskScheduler.shared.submit(task)
        } catch {
            print("Не удалось отправить фоновую задачу: \(error.localizedDescription)")
        }
    }
    
    func scheduleLocalNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "GPTalk"
        content.body = "Have fun with GPTalks! We have some interesting scenarios, choose the best 🙂"
        content.sound = UNNotificationSound.default
        
        let currentDate = Date()
        let calendar = Calendar.current
        let threeDaysLater = calendar.date(byAdding: .day, value: 3, to: currentDate)!
        let sixDaysLater = calendar.date(byAdding: .day, value: 6, to: currentDate)!
        let nineDaysLater = calendar.date(byAdding: .day, value: 9, to: currentDate)!
        
        let identifiers = ["ThreeDaysNotification", "SixDaysNotification", "NineDaysNotification"]
        
        let dates = [threeDaysLater, sixDaysLater, nineDaysLater]
        
        for i in 0..<3 {
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dates[i])
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: identifiers[i], content: content, trigger: trigger)
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print("Ошибка при добавлении уведомления: \(error.localizedDescription)")
                }
            }
        }
    }
}
