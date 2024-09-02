//
//  WebViewLink.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/2/24.
//

import SwiftUI

struct WebViewLink: Identifiable {
    let id: UUID = .init()
    let string: String
    var request: URLRequest { URLRequest(url: URL(string: string)!) }
}
