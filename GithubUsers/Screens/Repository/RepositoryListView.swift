//
//  RepositoryListScreen.swift
//  GithubUsers
//
//  Created by TokyoBits on 8/29/24.
//

import SwiftUI
import SwiftData
import WebUI

struct RepositoryListView: View {
    let username: String
    @State private var networkManager = NetworkManager.shared
    @State private var repos: [Repository] = []
    @State private var selectedLink: WebViewLink?

    var body: some View {
        List {
            Section("Repositories (\(repos.count))") {
                ForEach(repos) { repository in
                    RepositoryRowView(repository: repository)
                        .onTapGesture {
                            selectedLink = WebViewLink(string: repository.url)
                        }
                }
            }
        }
        .refreshable {
            await fetchRepositories()
        }
        .listStyle(.plain)
        .offset(y: -8) /// Workaround: Header has gap at top after scrolling without this
        .ignoresSafeArea()
        .task {
            await fetchRepositories()
        }
        .sheet(item: $selectedLink) { link in
            CustomWebView(request: link.request)
                .interactiveDismissDisabled()
                .overlay(alignment: .topTrailing) {
                    overlayCloseButton
                }
        }
    }

    private var overlayCloseButton: some View {
        Button {
            selectedLink = nil
        } label: {
            Image(systemName: "xmark")
                .imageScale(.small)
                .padding(8)
                .background(.white)
                .clipShape(.circle)
                .shadow(radius: 5)
        }
        .padding(.top, 10)
        .padding(.trailing, 20)
    }

    // MARK: - Functions
    private func fetchRepositories() async {
        do {
            repos = try await networkManager.fetchRepositories(for: username)
        } catch {
            print(error)
        }
    }
}

#Preview {
    RepositoryListView(username: "twostraws")
}
