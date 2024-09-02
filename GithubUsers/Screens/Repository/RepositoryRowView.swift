//
//  RepositoryRowView.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/2/24.
//

import SwiftUI

struct RepositoryRowView: View {
    let repository: Repository

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                starView
                repositoryTextView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 12)
    }

    private var starView: some View {
        VStack {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
                .font(.system(size: 24))

            Text(Int(repository.starsCount).formatted(.number.notation(.compactName)))
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
                .shadow(radius: 5)
        }
        .foregroundStyle(.primary)
        .padding(.trailing, 8)

    }

    private var repositoryTextView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(repository.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                if let language = repository.language {
                    Text(language)
                        .tokenized()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }

            Text(repository.description ?? "")
                .font(.caption)
            Text("Updated: " + repository.lastUpdated.formatted(
                    .relative(
                        presentation: .numeric,
                        unitsStyle: .narrow
                    )
                )
            )
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.top, 4)
        }
    }
}

#Preview {
    List {
        RepositoryRowView(
            repository: Repository(
                id: 1,
                name: "Inferno",
                description: "Metal Shaders for SwiftUI.",
                language: "Metal",
                isFork: false,
                starsCount: 10000,
                url: "https://github.com/twostraws/Inferno",
                lastUpdated: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
            )
        )
    }
    .listStyle(.plain)
}
