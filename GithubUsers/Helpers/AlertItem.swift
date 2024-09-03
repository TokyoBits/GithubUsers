//
//  AlertItem.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id: UUID = .init()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidURL = AlertItem(
        title: Text("Server Error"),
        message: Text("The URL was not a valid GitHub URL"),
        dismissButton: .default(Text("OK"))
    )

    static let invalidResponse = AlertItem(
        title: Text("Request Error"),
        message: Text("The server has responded with an invalid status code"),
        dismissButton: .default(Text("OK"))
    )

    static let invalidData = AlertItem(
        title: Text("Invalid Data"),
        message: Text("The server reponded with data that could not be decoded"),
        dismissButton: .default(Text("OK"))
    )

    static let rateLimitExceeded = AlertItem(
        title: Text("Rate Limit Exceeded"),
        message: Text("GitHub API rate limit has been exceeded. Verify you have setup your token in Info.plist"),
        dismissButton: .default(Text("OK"))
    )
}
