//
//  UserDetailViewModelTests.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import Testing
@testable import GithubUsers

struct UserDetailViewModelTests {

    @Test func fetchUserSuccessfully() async throws {
        let enteredName = "tokyobits"
        let viewModel = UserDetailViewModel(username: enteredName)

        #expect(viewModel.user == nil)

        await viewModel.fetchUserDetails()

        #expect(viewModel.user?.fullName == "TokyoBits")
    }

    @Test func fetchUserDetailSuccessfully() async throws {
        let enteredName = "twostraws"
        let viewModel = UserDetailViewModel(username: enteredName)

        #expect(viewModel.user == nil)

        await viewModel.fetchUserDetails()

        #expect(viewModel.user?.fullName == "Paul Hudson")
        #expect(viewModel.user?.company == "Hacking with Swift")
        #expect(viewModel.user?.location == "Bath, UK")
    }

    @Test func throwErrorFetchingFakeUserDetail() async throws {
        let enteredName = "99tOkYoBiTs99"
        let viewModel = UserDetailViewModel(username: enteredName)

        await viewModel.fetchUserDetails()

        #expect(viewModel.alertItem != nil)
    }
}
