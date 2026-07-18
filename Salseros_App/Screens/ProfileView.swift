//
//  ProfileView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// User profile screen with yearly fitting stats and saved preferences.

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var profiles: [UserProfile]
    @Query private var fittings: [Fitting]

    //hardcoded since right now it's only one user
    //if there was a log-in then this should match logged in user
    private var profile: UserProfile? {
        profiles.first
    }

    //This is dynamically calculated each time
    //Could make this saved under profile data
    private var nightsThisYear: Int {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: .now)

        return fittings.filter { fitting in
            calendar.component(.year, from: fitting.date) == currentYear
        }.count
    }

    var body: some View {
        //This is the current screen for user profile
        NavigationStack {
            List {
                Section("Profile") {
                    LabeledContent("Name", value: profile?.name ?? "You")
                        .font(.cardMeta)
                    LabeledContent("Nights this year", value: "\(nightsThisYear)")
                        .font(.cardMeta)
                }
                .listRowBackground(Color.cardCream)

                if let profile, !profile.preferredStyles.isEmpty {
                    Section("Preferred styles") {
                        ForEach(profile.preferredStyles.map(\.rawValue).sorted(), id: \.self) { style in
                            Text(style)
                                .font(.cardMeta)
                                .foregroundStyle(Color.ink)
                        }
                    }
                    .listRowBackground(Color.cardCream)
                }

                if let profile, !profile.friendNames.isEmpty {
                    Section("Friends") {
                        ForEach(profile.friendNames, id: \.self) { friendName in
                            Text(friendName)
                                .font(.cardMeta)
                                .foregroundStyle(Color.ink)
                        }
                    }
                    .listRowBackground(Color.cardCream)
                }
            }
            .navigationTitle("Noe's Profile")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .espressoBackground()
        }
        .espressoBackground()
    }
}
