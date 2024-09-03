//
//  RepositoryListViewModelTests.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import Testing
@testable import GithubUsers

struct RepositoryListViewModelTests {

    @Test func fetchUserRepoSuccessfully() async throws {
        let enteredName = "tokyobits"
        let viewModel = RepositoryListViewModel(username: enteredName)

        #expect(viewModel.repos.count == 0)
        #expect(viewModel.isLoading == true)

        await viewModel.fetchRepositories()

        #expect(viewModel.repos.count == 2)
        #expect(viewModel.isLoading == false)
    }

    @Test func fetchUserCaseInsensitive() async throws {
        let enteredName = "tOkYoBiTs"
        let viewModel = RepositoryListViewModel(username: enteredName)

        #expect(viewModel.repos.count == 0)

        await viewModel.fetchRepositories()

        #expect(viewModel.repos.count == 2)
    }

    @Test func throwErrorFetchingFakeUserRepos() async throws {
        let enteredName = "99tOkYoBiTs99"
        let viewModel = RepositoryListViewModel(username: enteredName)

        await viewModel.fetchRepositories()

        #expect(viewModel.alertItem != nil)
    }
}
