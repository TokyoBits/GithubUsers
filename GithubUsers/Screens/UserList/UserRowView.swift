//
//  UserRowView.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/3/24.
//

import SwiftUI

public struct UserRowView: View {
    let username: String
    let imageURL: String

    public var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .circularImage()
            } placeholder: {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .circularImage()
            }
            Text(username)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    List {
        UserRowView(username: "twostraws", imageURL: "")
    }
}
