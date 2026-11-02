//  DeepDiveApp.swift
//  DeepDive
//  Created on 10/23/26.
import SwiftData
import SwiftUI

@main
struct DeepDiveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, Investigation.self])
    }
}
