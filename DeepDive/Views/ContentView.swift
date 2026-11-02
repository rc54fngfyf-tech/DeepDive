//  ContentView.swift
//  DeepDive
//  Created on 10/23/26.
import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            
            Tab("Favorites", systemImage: "heart") {
                FavoritesView()
            }
            
            Tab("Add", systemImage: "plus.circle") {
                AddView()
            }
            
            Tab("Connect", systemImage: "figure.2") {
                ConnectView()
            }
        }
        .tabViewStyle(.tabBarOnly)
    }
}

#Preview {
    ContentView()
}
