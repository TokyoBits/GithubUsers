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
        Group {
            if viewModel.repos.isEmpty && !viewModel.isLoading {
                unavailableView
            } else {
                if viewModel.isLoading {
                    initialLoadingView
                } else {
                    repositoryListView
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
                }
            }
        }
        .task {
            if viewModel.isLoading {
                await viewModel.fetchRepositories()
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
    }

    private var unavailableView: some View {
        ContentUnavailableView {
            Label("No Repositories", systemImage: "books.vertical.circle")
        } description: {
            Text("The user has no repositories or there was an error fetching them")
        }
    }

    private var initialLoadingView: some View {
        ContentUnavailableView {
            Image(systemName: "books.vertical.circle")
                .font(.system(size: 40))
                .symbolEffect(.pulse)
                .foregroundStyle(.gray)
            Text("Loading Repositories")
                .font(.title2)
                .fontWeight(.semibold)
        }
    }

    private var repositoryListView: some View {
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
