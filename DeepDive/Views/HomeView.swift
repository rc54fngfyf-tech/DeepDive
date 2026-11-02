//  HomeView.swift
//  DeepDive
//  Created on 10/23/26.
import LocalAuthentication
import SwiftData
import SwiftUI
import UserNotifications

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query var investigations: [Investigation] = []
    @State private var showingAddView = false
    @State private var showingDetailView = false
    @State private var isDeletingInvestigation = false
    @State private var pendingDelete: IndexSet?
    @State private var selectedInvestigation: Investigation?
    
    var body: some View {
        NavigationStack {
            List {
                Section("My Investigations") {
                    ForEach(investigations) { investigation in
                        Button {
                            if investigation.requiresAuthentication == true {
                                Task {
                                    if await requireAuthentication(investigation: investigation) == true {
                                        selectedInvestigation = investigation
                                        showingDetailView = true
                                    }
                                }
                            } else {
                                selectedInvestigation = investigation
                                showingDetailView = true
                            }
                        } label: {
                            RowView(investigation: investigation)
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                modelContext.delete(investigation)
                            }
                            
                            if investigation.isFavorite == true {
                                Button("Unfavorite", systemImage: "heart.slash.fill") {
                                    investigation.isFavorite = false
                                }
                            } else {
                                Button("Favorite", systemImage: "heart") {
                                    investigation.isFavorite = true
                                }
                                .tint(.pink)
                            }
                        }
                        .swipeActions(edge: .leading) {
                            if investigation.requiresAuthentication == true {
                                Button("Disable Authentication", systemImage: "lock.open.fill") {
                                    investigation.requiresAuthentication = false
                                }
                                .tint(.gray)
                            } else {
                                Button("Require Authentication", systemImage: "lock") {
                                    Task {
                                        let authenticationWorked = await requireAuthentication(investigation: investigation)
                                        
                                        if authenticationWorked {
                                            investigation.requiresAuthentication = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                AddButtonView(showingAddView: $showingAddView)
            }
            .onAppear(perform: handleNotifications)
            .alert("Deleting Investigation", isPresented: $isDeletingInvestigation) {
                Button("Delete", role: .destructive) {
                    if let pendingDelete {
                        for offset in pendingDelete {
                            modelContext.delete(investigations[offset])
                        }
                    } else {
                        pendingDelete = nil
                    }
                }
                Button("Cancel", role: .cancel) { pendingDelete = nil }
            } message: {
                Text("Are you sure you want to delete this investigation?")
            }
            .navigationTitle("DeepDive")
            .navigationSubtitle("Investigate claims. Follow the evidence.")
            .navigationDestination(isPresented: $showingAddView) {
                AddView()
            }
            .navigationDestination(isPresented: $showingDetailView) {
                if let investigation = selectedInvestigation {
                    DetailView(investigation: investigation)
                }
            }
        }
    }
    
    func deleteInvestigations(offsets: IndexSet) {
        pendingDelete = offsets
        isDeletingInvestigation = true
    }
    
    func requireAuthentication(investigation: Investigation) async -> Bool {
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
    
    func handleNotifications() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                let unfinishedInvestigations = investigations.filter { investigation in
                    investigation.isFinished == false
                }
                
                let content = UNMutableNotificationContent()
                
                let title = "Investigation Review"
                //let body = unfinishedInvestigations.count == 1 ? "You have \(unfinishedInvestigations.count) investigation" : "You have \(unfinishedInvestigations.count) investigations"
                let body = "Come back to finish your investigations that are still in progress."
                let sound = UNNotificationSound.default
                
                content.title = title
                content.body = body
                content.sound = sound
                
                let hour = 17
                let minutes = 30
                
                let request = UNNotificationRequest(identifier: "Daily Investigation Reminder", content: content, trigger: UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: hour, minute: minutes), repeats: true))
                
                if unfinishedInvestigations.count > 0 {
                    center.add(request)
                } else {
                    center.removeDeliveredNotifications(withIdentifiers: ["Daily Investigation Reminder"])
                    center.removePendingNotificationRequests(withIdentifiers: ["Daily Investigation Reminder"])
                }
            } else {
                print("Notifications not granted")
            }
        }
    }
}

struct AddButtonView: View {
    @Binding var showingAddView: Bool
    
    var body: some View {
        Button {
            showingAddView = true
        } label: {
            Label("New Investigation", systemImage: "plus.circle")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .foregroundStyle(.white)
                .background(Color.green.gradient)
                .shadow(radius: 5)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
    
struct RowView: View {
    @Environment(\.modelContext) var modelContext
    let investigation: Investigation
    
    var body: some View {
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


#Preview {
    HomeView()
}
