//
//  UserSearchFormViewModelTests.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import Testing
@testable import GithubUsers

struct UserSearchFormViewModelTests {

    @Test func findExistingUserTest() async throws {
        let username = "tokyobits"

        let viewModel = UserSearchFormViewModel()

        await viewModel.fetchUser(username: username)

        #expect(viewModel.alertItem == nil)
        #expect(viewModel.hasSearched == true)
        #expect(viewModel.fetchedUser != nil)
    }

    @Test func successfullyResetUserTest() async throws {
        let enteredName = "tokyobits"

        let viewModel = UserSearchFormViewModel()

        await viewModel.fetchUser(username: enteredName)

        #expect(viewModel.hasSearched == true)
        #expect(viewModel.fetchedUser?.username.lowercased() == enteredName.lowercased())

        viewModel.resetSearch()

        #expect(viewModel.hasSearched == false)
        #expect(viewModel.fetchedUser == nil)
        #expect(viewModel.username.isEmpty)
    }

    @Test func doNotFindFakeUserTest() async throws {
        let username = "tokyobits9999999999999"

        let viewModel = UserSearchFormViewModel()

        await viewModel.fetchUser(username: username)

        #expect(viewModel.alertItem == nil)
        #expect(viewModel.hasSearched == true)
        #expect(viewModel.fetchedUser == nil)
    }
}
