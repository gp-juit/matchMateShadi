//
//  UserDataModel.swift
//  MatchMate-Shaddi
//
//  Created by Gurpreet Singh on 03/12/24.
//

import Foundation
import CoreData

enum ProfileStatus: String, Codable {
    case accepted = "Accepted"
    case declined = "Declined"
    case pending = "Pending"
}


// MARK: - UserResponse
struct UserResponse: Codable {
    let results: [UserData]
    let info: Info
}

// MARK: - UserData
struct UserData: Codable, Identifiable {
    let gender: Gender
    let name: UserName
    let location: UserLocation
    let email: String
    let login: Login
    let dob: Dob
    let registered: Registered
    let phone: String
    let cell: String
    let id: IDData
    let picture: UserPicture
    let nat: String
    
    // Custom properties
    var isAccepted: Bool = false
    var status: ProfileStatus = .pending
}

// MARK: - Info
struct Info: Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

// MARK: - Dob
struct Dob: Codable {
    let date: String
    let age: Int
}

// MARK: - Registered
struct Registered: Codable {
    let date: String
    let age: Int
}

// MARK: - Gender
enum Gender: String, Codable {
    case female = "female"
    case male = "male"
}

// MARK: - IDData
struct IDData: Codable, Hashable {
    let name: String
    let value: String?
}

// MARK: - UserLocation
struct UserLocation: Codable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let postcode: CodablePostcode
    let coordinates: Coordinates
    let timezone: Timezone
}

// MARK: - Street
struct Street: Codable {
    let number: Int
    let name: String
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude: String
    let longitude: String
}

// MARK: - Timezone
struct Timezone: Codable {
    let offset: String
    let description: String
}

// MARK: - Login
struct Login: Codable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

// MARK: - UserName
struct UserName: Codable {
    let title: Title
    let first: String
    let last: String
}

// MARK: - Title
enum Title: String, Codable {
    case miss = "Miss"
    case mr = "Mr"
    case mrs = "Mrs"
}

// MARK: - UserPicture
struct UserPicture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

// MARK: - CodablePostcode
enum CodablePostcode: Codable {
    case intValue(Int)
    case stringValue(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .intValue(intValue)
            return
        }
        if let stringValue = try? container.decode(String.self) {
            self = .stringValue(stringValue)
            return
        }
        throw DecodingError.typeMismatch(CodablePostcode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Int or String"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .intValue(let intValue):
            try container.encode(intValue)
        case .stringValue(let stringValue):
            try container.encode(stringValue)
        }
    }
}




extension UserData {
    init(from entity: UserProfileData) {
        self.id = IDData(name: "UserID", value: entity.id ?? "")
        self.name = UserName(title: .mr, first: entity.firstName ?? "", last: entity.lastName ?? "")
        self.location = UserLocation(street: Street(number: 0, name: ""), city: entity.city ?? "", state: entity.state ?? "", country: "", postcode: .stringValue(""), coordinates: Coordinates(latitude: "", longitude: ""), timezone: Timezone(offset: "", description: ""))
        self.dob =  Dob(date: "", age: Int(entity.age))
        self.picture = UserPicture(large: entity.imageUrl ?? "", medium: "", thumbnail: "")
        self.isAccepted = entity.isAccepted
        self.gender = .male 
        self.email = ""
        self.login = Login(uuid: "", username: "", password: "", salt: "", md5: "", sha1: "", sha256: "")
        self.registered = Registered(date: "", age: 0)
        self.phone = ""
        self.cell = ""
        self.nat = ""
    }
}

extension UserProfileData {
    func update(with profile: UserData) {
        self.id = profile.id.value
        self.firstName = profile.name.first
        self.lastName = profile.name.last
        self.city = profile.location.city
        self.state = profile.location.state
        self.age = Int32(profile.dob.age)
        self.imageUrl = profile.picture.large
        self.isAccepted = profile.isAccepted
    }
}


