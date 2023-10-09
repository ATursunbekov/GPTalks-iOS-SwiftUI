//
//  MainTabView.swift
//  GpTalks-iOSApp
//
//  Created by Aidar Asanakunov on 20/7/23.
//
import SwiftUI
import Adapty
import EasySkeleton

struct MainTabView: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @State private var selectedIndex = 0
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var hasPremium: Bool = false
    @State private var showLoaderCategory = true
    
    init() {
        UITextView.appearance().backgroundColor = .black
        let appearance = UITabBarAppearance()
        appearance.shadowColor = Colors.SeparatorColor.separator01.color
        appearance.backgroundColor = Colors.SystemBackgrounds.background01.color
        appearance.stackedLayoutAppearance.normal.iconColor = Colors.LabelColor.label02.color
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: FontFamily.SFProDisplay.medium.family, size: 10)!]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.LabelColor.label02.color]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                TabView(selection: $selectedIndex) {
                    HomeView(showLoaderHome: $categoryViewModel.showLoaderHome)
                        .onTapGesture {
                            self.selectedIndex = 0
                        }
                        .tabItem {
                            Image(AssetsImage.Icons.chat.name)
                            
                            Text("Chat")
                        }.tag(0)
                    
                    CategoryView(showLoaderCategory: $categoryViewModel.showLoaderCategory)
                        .onTapGesture {
                            self.selectedIndex = 1
                        }
                        .tabItem {
                            Image(AssetsImage.Icons.category.name)
                            
                            Text("Categories")
                        }.tag(1)
                    
                    FavoriteView(showLoaderFavorite: $categoryViewModel.showLoaderHome)
                        .onTapGesture {
                            self.selectedIndex = 2
                        }
                        .tabItem {
                            Image(AssetsImage.Icons.heart24.name)
                                .renderingMode(.template)
                                .accentColor(Colors.DefaultColors.green.swiftUIColor)
                            
                            Text("Favorite")
                        }.tag(2)
                    
                    HistoryView(isLoading: $categoryViewModel.showLoaderHome)
                        .onTapGesture {
                            self.selectedIndex = 3
                        }
                        .tabItem {
                            Image(AssetsImage.Icons.history.name)
                            
                            Text("History")
                        }.tag(3)
                }
                .accentColor(Colors.DefaultColors.green.swiftUIColor)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Text("GPTalk")
                                .font(.custom(FontFamily.Poppins.bold, size: 28))
                                .foregroundColor(.white)
                                .skeletonable()
                                .skeletonCornerRadius(8)
                            
                            if purchaseViewModel.hasPremium {
                                Image(AssetsImage.HeaderIcons.pro.name)
                                    .frame(width: 36, height: 18)
                            }
                        }
                        .skeletonable()
                        .skeletonCornerRadius(8)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 12) {
                            Button {
                                ShareHelper().share()
                            } label: {
                                Image(AssetsImage.Icons.share.name)
                            }
                            .frame(width: 24, height: 24)
                            
                            NavigationLink {
                                SettingsView()
                            } label: {
                                Image(AssetsImage.Icons.settings.name)
                            }
                            .frame(width: 24, height: 24)
                            
                            if !purchaseViewModel.hasPremium {
                                Button {
                                    UserDefaults.standard.set(true, forKey: "showPayWall")
                                } label:  {
                                    Image(AssetsImage.HeaderIcons.proIcon.name)
                                }
                                .frame(width: 65, height: 31)
                            }
                        }
                        .skeletonable()
                        .skeletonCornerRadius(8)
                    }
                }
                .setSkeleton($categoryViewModel.showLoaderHome, animationType: .gradient([Colors.LinearGradient.colorGradient2.swiftUIColor,Colors.LinearGradient.colorGradient1.swiftUIColor]), animation: .linear(duration: 0.3), transition: .opacity)
            }
            .accentColor(.white)
            .onAppear {
                categoryViewModel.fetchHomeTopics()
                categoryViewModel.fetchCategories()
            }
        } 
        else {
            NavigationView {
                TabView(selection: $selectedIndex) {
                    HomeView(showLoaderHome: $categoryViewModel.showLoaderHome)
                        .onTapGesture {
                            self.selectedIndex = 0
                        }
                        .tabItem {
                            Image(AssetsImage.Icons.chat.name)
                            
                            Text("Chat")
                        }.tag(0)
                    
                    CategoryView(showLoaderCategory: $categoryViewModel.showLoaderCategory)
                        .onTapGesture {
                            self.selectedIndex = 1
                        }
                        .tabItem {
                            Image(AssetsImage.Icons.category.name)
                            
                            Text("Categories")
                        }.tag(1)
                    
                    FavoriteView(showLoaderFavorite: $categoryViewModel.showLoaderHome)
                        .onTapGesture {
                            self.selectedIndex = 2
                        }
                        .tabItem {
                            Image(AssetsImage.Icons.heart24.name)
                                .renderingMode(.template)
                                .accentColor(Colors.DefaultColors.green.swiftUIColor)
                            
                            Text("Favorite")
                        }.tag(2)
                    
                    HistoryView(isLoading: $categoryViewModel.showLoaderHome)
                        .onTapGesture {
                            self.selectedIndex = 3
                        }
                        .tabItem {
                            Image(AssetsImage.Icons.history.name)
                            
                            Text("History")
                        }.tag(3)
                }
                .accentColor(Colors.DefaultColors.green.swiftUIColor)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Text("GPTalk")
                                .font(.custom(FontFamily.Poppins.bold, size: 28))
                                .foregroundColor(.white)
                                .skeletonable()
                                .skeletonCornerRadius(8)
                            
                            if purchaseViewModel.hasPremium {
                                Image(AssetsImage.HeaderIcons.pro.name)
                                    .frame(width: 36, height: 18)
                            }
                        }
                        .skeletonable()
                        .skeletonCornerRadius(8)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 12) {
                            Button {
                                ShareHelper().share()
                            } label: {
                                Image(AssetsImage.Icons.share.name)
                            }
                            .frame(width: 24, height: 24)
                            
                            NavigationLink {
                                SettingsView()
                            } label: {
                                Image(AssetsImage.Icons.settings.name)
                            }
                            .frame(width: 24, height: 24)
                            
                            if !purchaseViewModel.hasPremium {
                                Button {
                                    UserDefaults.standard.set(true, forKey: "showPayWall")
                                } label:  {
                                    Image(AssetsImage.HeaderIcons.proIcon.name)
                                }
                                .frame(width: 65, height: 31)
                            }
                        }
                        .skeletonable()
                        .skeletonCornerRadius(8)
                    }
                }
                .setSkeleton($categoryViewModel.showLoaderHome, animationType: .gradient([Colors.LinearGradient.colorGradient2.swiftUIColor,Colors.LinearGradient.colorGradient1.swiftUIColor]), animation: .linear(duration: 0.3), transition: .opacity)
            }
            .navigationViewStyle(.stack)
            .accentColor(.white)
            .onAppear {
                categoryViewModel.fetchHomeTopics()
                categoryViewModel.fetchCategories()
            }
        }
    }
}

//struct MainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView()
//            .environmentObject(CategoryViewModel())
//    }
//}
