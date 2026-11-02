//  Investigation.swift
//  DeepDive
//  Created on 10/23/26.
import SwiftData
import SwiftUI

@Model
class Investigation: Identifiable {
    var id = UUID()
    var claim: String
    var source: String
    var evidence: String
    var questions: String
    var conclusion: String
    var requiresAuthentication: Bool = false
    var isFinished: Bool = false
    var isFavorite: Bool = false

    init(id: UUID = UUID(), claim: String, source: String, evidence: String, questions: String, conclusion: String, requiresAuthentication: Bool, isFinished: Bool, isFavorite: Bool) {
        self.id = id
        self.claim = claim
        self.source = source
        self.evidence = evidence
        self.questions = questions
        self.conclusion = conclusion
        self.requiresAuthentication = requiresAuthentication
        self.isFinished = isFinished
        self.isFavorite = isFavorite
    }
}
