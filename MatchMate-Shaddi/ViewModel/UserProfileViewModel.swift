//
//  UserProfileViewModel.swift
//  MatchMate-Shaddi
//
//  Created by Gurpreet Singh on 04/12/24.
//

import SwiftUI
import CoreData

class ProfileViewModel: ObservableObject {
    @Published var profiles: [UserData] = []
    private let context = PersistenceController.shared.container.viewContext

    init() {
        fetchProfiles()
    }

    // MARK: - Update Profile Status
    func updateProfileStatus(profile: UserData, isAccepted: Bool) {
        if let index = profiles.firstIndex(where: { $0.id.value == profile.id.value }) {
            profiles[index].status = isAccepted ? .accepted : .declined

            let fetchRequest: NSFetchRequest<UserProfileData> = UserProfileData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", profile.id.value ?? "")

            do {
                if let result = try context.fetch(fetchRequest).first {
                    result.isAccepted = isAccepted
                    try context.save()
                } else {
                    print("No matching profile found in Core Data.")
                }
            } catch {
                print("Failed to update Core Data: \(error.localizedDescription)")
            }
        } else {
            print("Profile not found in memory.")
        }
    }

    // MARK: - Fetch Profiles
    func fetchProfiles() {
        let fetchRequest: NSFetchRequest<UserProfileData> = UserProfileData.fetchRequest()
        do {
            let storedProfiles = try context.fetch(fetchRequest)
            if storedProfiles.isEmpty {
                fetchFromAPI()
            } else {
                self.profiles = storedProfiles.map { storedProfileToUserData($0) }
            }
        } catch {
            print("Failed to fetch profiles from Core Data: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch from API
    func fetchFromAPI() {
        guard let url = URL(string: "https://randomuser.me/api/?results=10") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                print("No data received from API.")
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                let profiles = apiResponse.results
                DispatchQueue.main.async {
                    self.profiles = profiles
                    self.saveToCoreData(profiles)
                }
            } catch {
                print("Failed to decode API data: \(error.localizedDescription)")
            }
        }.resume()
    }

    // MARK: - Save to Core Data
    func saveToCoreData(_ profiles: [UserData]) {
        profiles.forEach { profile in
            let entity = UserProfileData(context: context)
            entity.id = profile.id.value
            entity.firstName = profile.name.first
            entity.lastName = profile.name.last
            entity.age = Int32(profile.dob.age)
            entity.state = profile.location.state
            entity.city = profile.location.city
            entity.imageUrl = profile.picture.large
            entity.isAccepted = profile.isAccepted
        }

        do {
            try context.save()
        } catch {
            print("Failed to save profiles to Core Data: \(error.localizedDescription)")
        }
    }

    // MARK: - Helper: Convert Stored Data to UserData
    private func storedProfileToUserData(_ profile: UserProfileData) -> UserData {
        return UserData(
            gender: .male,
            name: UserName(
                title: .mr,
                first: profile.firstName ?? "",
                last: profile.lastName ?? ""
            ),
            location: UserLocation(street: Street(number: 0, name: ""), city: profile.city ?? "", state: profile.state ?? "", country: "", postcode: .stringValue(""), coordinates: Coordinates(latitude: "", longitude: ""), timezone: Timezone(offset: "", description: "")),
            email: "",
            login: Login(
                uuid: "",
                username: "",
                password: "",
                salt: "",
                md5: "",
                sha1: "",
                sha256: ""
            ),
            dob: Dob(date: "", age: Int(profile.age)),
            registered: Registered(date: "", age: 0),
            phone: "",
            cell: "",
            id: IDData(name: "UserID", value: profile.id ?? ""),
            picture: UserPicture(
                large: profile.imageUrl ?? "",
                medium: "",
                thumbnail: ""
            ),
            nat: "", 
            isAccepted: profile.isAccepted
        )
    }

}
