//
//  AmplitudeManager.swift
//  GpTalks-iOSApp
//
//  Created by Nurzhan Ababakirov on 20/9/23.
//

import AmplitudeSwift

class AmplitudeManager {
    static let shared = AmplitudeManager()
    
    private let amplitude: Amplitude
    
    private init() {
        let configuration = Configuration(apiKey: "14817f475be5bf52d3e58609e44f6776")
        amplitude = Amplitude(configuration: configuration)
    }
    
    func logFirstLogin() {
        amplitude.track(eventType: "First launch")
    }
    
    func firstOnboarding() {
        amplitude.track(eventType: "First onboarding")
    }
    
    func secondOnBoarding() {
        amplitude.track(eventType: "Second onboarding")
    }
    
    func thirdOnBoarding() {
        amplitude.track(eventType: "Third onboarding")
    }
    
    func fourthOnBoarding() {
        amplitude.track(eventType: "Fourth onboarding")
    }
    
    func fifthOnBoarding() {
        amplitude.track(eventType: "Fifth onboarding")
    }
    
    func boughtMonthly() {
        amplitude.track(eventType: "Monthly access bought")
    }
    
    func boughtAnnual() {
        amplitude.track(eventType: "Annual access bought")
    }
    
    func bannerOpened() {
        amplitude.track(eventType: "Tap on banner")
    }
    
    func boughtScenario() {
        amplitude.track(eventType: "Bought personal scenario")
    }
    
    func suggestionPressed(){
        amplitude.track(eventType: "Tap on Suggestions")
    }
    
    func messageSaved(){
        amplitude.track(eventType: "Tap on message favorite")
    }
}
