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
    @State private var viewModel: RepositoryListViewModel
    @State private var selectedLink: WebViewLink?

    init(username: String  = "") {
        self.viewModel = RepositoryListViewModel(username: username)
    }

    var body: some View {
        List {
            Section("Repositories (\(viewModel.repos.count))") {
                ForEach(viewModel.repos) { repository in
                    RepositoryRowView(repository: repository)
                        .onTapGesture {
                            selectedLink = WebViewLink(string: repository.url)
                        }
                }
            }
        }
        .refreshable {
            await viewModel.fetchRepositories()
        }
        .task {
            await viewModel.fetchRepositories()
        }
        .listStyle(.plain)
        .offset(y: -8) /// Workaround: Header has gap at top after scrolling without this
        .ignoresSafeArea()
        .sheet(item: $selectedLink) { link in
            CustomWebView(request: link.request)
                .interactiveDismissDisabled()
                .overlay(alignment: .topTrailing) {
                    overlayCloseButton
                }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
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
}

#Preview {
    RepositoryListView(username: "twostraws")
}
