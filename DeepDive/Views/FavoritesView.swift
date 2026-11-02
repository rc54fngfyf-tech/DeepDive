//  FavoritesView.swift
//  DeepDive
//  Created on 10/23/26.
import LocalAuthentication
import SwiftData
import SwiftUI

struct FavoritesView: View {
    @Query var investigations: [Investigation]
    @State private var selectedInvestigation: Investigation?
    @State private var showingDetailView = false
    
    var body: some View {
        NavigationStack {
            List {
                let favorites = investigations.filter { item in
                    item.isFavorite
                }
                
                if favorites.isEmpty {
                    Text("No favorites yet")
                        .font(.title)
                } else {
                    ForEach(favorites) { investigation in
                        Button {
                            if investigation.requiresAuthentication == true {
                                Task {
                                    if await requireAuthentication() {
                                        showingDetailView = true
                                        selectedInvestigation = investigation
                                    }
                                }
                            } else {
                                showingDetailView = true
                                selectedInvestigation = investigation
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                Text(investigation.claim)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text(investigation.isFinished ? "Finished" : "In Progress")
                                    .font(.subheadline)
                                    .foregroundStyle(investigation.isFinished ? Color.green : Color.orange)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorite Investigations")
            .navigationDestination(isPresented: $showingDetailView) {
                if let investigation = selectedInvestigation {
                    DetailView(investigation: investigation)
                }
            }
            .toolbar {
                ShareLink(item: "This app gives you the space you need to save and write down any information you may be investing. Download DeepDive.", preview: SharePreview("Share DeepDive"))
            }
        }
    }
    
    func requireAuthentication() async -> Bool {
        let context = LAContext()
        var error: NSError?
        let reason = "To keep your investigation secure."
        
        do {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return false
    }
}

#Preview {
    FavoritesView()
}
