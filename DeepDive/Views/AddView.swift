//  AddView.swift
//  DeepDive
//  Created on 10/23/26.
import SwiftData
import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var claim = ""
    @State private var source = ""
    @State private var evidence = ""
    @State private var questions = ""
    @State private var conclusion = ""
    @State private var isFinished = false
    
    @State private var showingHomeView = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Claim") {
                    TextField("What is your claim?", text: $claim, axis: .vertical)
                }
                
                Section("Sources") {
                    TextField("What are your sources", text: $source, axis: .vertical)
                }
                
                Section("Evidence") {
                    TextField("What evidence do you have to support", text: $evidence, axis: .vertical)
                }
                
                Section("Conclusion") {
                    TextField("Conclusion about the investigation", text: $conclusion, axis: .vertical)
                }
                
                Section("Questions") {
                    TextField("What questions to ask", text: $questions, axis: .vertical)
                }
                
                Section("Status of Investigation") {
                    Toggle("Finished with Investigation?", isOn: $isFinished)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Add Investigation")
            .toolbar {
                Button("Save", systemImage: "checkmark") {
                    let investigation = Investigation(claim: claim, source: source, evidence: evidence, questions: questions, conclusion: conclusion, requiresAuthentication: false, isFinished: false, isFavorite: false)
                    modelContext.insert(investigation)
                    dismiss()
                    claim = ""
                    source = ""
                    evidence = ""
                    questions = ""
                    conclusion = ""
                    isFinished = false
                    showingHomeView = true
                }
            }
        }
    }
}

#Preview {
    AddView()
}
