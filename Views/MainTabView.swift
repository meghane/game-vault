//
//  MainTabView.swift
//  GameVault
//
//  Created by meghan on 11/20/24.
//

import SwiftUI

//tabs at the bottom of the screen
struct MainTabView: View {
    @EnvironmentObject var authStateManager: AuthenticationStateManager
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            FilterView()
                .tabItem {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Filter")
                }
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Favorites")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .tint(.black)
    }
}
