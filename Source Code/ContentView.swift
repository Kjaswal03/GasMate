//
//  ContentView.swift
//  GasMate
//
//  Created by Kashev Jaswal on 5/29/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel() 
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .environmentObject(viewModel)
            
            ListView()
                .tabItem {
                    Label("Gas", systemImage: "list.dash")
                }
                .environmentObject(viewModel)
            
            SummaryView()
                .tabItem {
                    Label("Summary", systemImage: "info.circle")
                }
                .environmentObject(viewModel)
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
                .environmentObject(viewModel)
        }
    }
}
