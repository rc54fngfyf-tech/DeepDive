//  DetailView.swift
//  DeepDive
//  Created on 10/23/26.
import SwiftData
import SwiftUI

struct DetailView: View {
    @Bindable var investigation: Investigation
    
    var body: some View {
        NavigationStack {
            List {
                Section("Claim") {
                    TextField("What is the claim?", text: $investigation.claim, axis: .vertical)
                }
                
                Section("Evidence") {
                    TextField("Evidence to support claim.", text: $investigation.evidence, axis: .vertical)
                }
                
                Section("Sources") {
                    TextField("Where did you get the information?", text: $investigation.source, axis: .vertical)
                }
                
                Section("What does it mean?") {
                    TextField("Questions to consider.", text: $investigation.questions, axis: .vertical)
                }
                
                Section("Conclusion") {
                    TextField("What is your conclusion?", text: $investigation.conclusion, axis: .vertical)
                }
                
                Toggle("Finished?", isOn: $investigation.isFinished)
            }
            .navigationTitle("Investigation Details")
            .toolbar {
                Button {
                    withAnimation {
                        investigation.isFavorite.toggle()
                    }
                } label: {
                    Label("Favorite", systemImage: investigation.isFavorite ? "heart.fill" : "heart")
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    DetailView(investigation: Investigation(claim: "Claim", source: "Source", evidence: "Evidence", questions: "Questions", conclusion: "Conclusion", requiresAuthentication: false, isFinished: false, isFavorite: false))
}
