//  User.swift
//  DeepDive
//  Created on 10/23/26.
import Foundation
import SwiftData
import SwiftUI

@Model
class User: Identifiable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var age: Int?
    var emailAddress: String
    
    init(id: UUID = UUID(), firstName: String, lastName: String, age: Int? = nil, emailAddress: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.emailAddress = emailAddress
    }
}
