//
//  GithubUsersApp.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI
import SwiftData

@main
struct GithubUsersApp: App {
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }

    init() {
        do {
            container = try ModelContainer(for: User.self, Repository.self)
        } catch {
            fatalError("Failed to create ModelContainer.")
        }
    }
}
