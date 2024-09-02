//
//  CustomWebView.swift
//  GithubUsers
//
//  Created by TokyoBits on 9/2/24.
//

import SwiftUI
import WebUI

struct CustomWebView: View {
    let request: URLRequest

    var body: some View {
        WebViewReader { proxy in
            VStack {
                WebView(request: request)
                    .background(.black)

                ProgressView(value: proxy.estimatedProgress)
                    .opacity(proxy.isLoading ? 1.0 : 0.1)

                HStack {
                    Button {
                        proxy.goBack()
                    } label: {
                        Image(systemName: "arrowtriangle.left.fill")
                            .padding(.trailing, 8)
                    }
                    .disabled(!proxy.canGoBack)

                    Button {
                        proxy.goForward()
                    } label: {
                        Image(systemName: "arrowtriangle.right.fill")
                            .padding(.leading, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .disabled(!proxy.canGoForward)

                    Button {
                        proxy.reload()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .padding()
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CustomWebView(
        request:
            URLRequest(
                url: URL(string: "https://github.com/twostraws/inferno")!
            )
    )
}
