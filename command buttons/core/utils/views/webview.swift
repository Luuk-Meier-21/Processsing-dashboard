//
//  webview.swift
//  Web-connector-test
//
//  Created by Luuk Meier on 27/12/2021.
//

import Foundation
import SwiftUI
import WebKit
import Combine

struct WebView: NSViewRepresentable {
    let url: String

    func makeNSView(context: Context) -> WKWebView {

        guard let url = URL(string: self.url) else {
            return WKWebView()
        }

        let webview = WKWebView()
        let request = URLRequest(url: url)
        webview.load(request)

        return webview
    }

    func updateNSView(_ nsView: WKWebView, context: Context) { }
}
