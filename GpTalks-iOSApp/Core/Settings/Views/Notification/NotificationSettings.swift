//
//  NotificationSettings.swift
//  GpTalks-iOSApp
//
//  Created by Alikhan Tursunbekov on 23/8/23.
//

import SwiftUI

struct NotificationSettings: View {
    @AppStorage("notifications") var notificationsEnabled = true
    @State var emailOn = true
    
    init(){
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        VStack(spacing: 24) {
            //MARK: First Section
            VStack(alignment: .leading, spacing: 2) {
                Text("PROFILE")
                    .padding(.leading, 16)
                    .font(.custom(FontFamily.SFProDisplay.medium, size: 12))
                    .foregroundColor(Colors.LabelColor.label03.swiftUIColor)
                ZStack {
                    VStack(spacing: 0) {
                        ZStack {
                            RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                                .frame(height: 44)
                                .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                            HStack {
                                Text("Push")
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Toggle("", isOn: $notificationsEnabled)
                                    .onChange(of: notificationsEnabled) { newValue in
                                        if newValue {
                                            NotificationManager.shared.daysNotifications()
                                            print("This is if condition - \(notificationsEnabled.description)")
                                        } else {
                                            NotificationManager.shared.cancelNotification()
                                            print("This is else condition - \(notificationsEnabled.description)")
                                        }
                                    }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        Button {
                            print("something")
                        } label: {
                            ZStack {
                                RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight])
                                    .frame(height: 44)
                                    .foregroundColor(Colors.FillColor.fill03.swiftUIColor)
                                HStack {
                                    Text("Email")
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $emailOn)
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .foregroundColor(.cyan)
                    
                    Divider()
                        .overlay{
                            Colors.DefaultColors.gray03.swiftUIColor
                        }
                        .padding(.leading, 16)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .padding(.top, 16)
        .background(Colors.SystemBackgrounds.background01.swiftUIColor.ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationSettings_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettings()
    }
}


