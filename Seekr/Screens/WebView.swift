////
////  WebView.swift
////  Seekr
////
////  Created to provide a SwiftUI-compatible web view.
////
//
//import SwiftUI
//import WebKit
//
///// Observable model to manage web page loading.
//class WebPage: ObservableObject {
//    @Published var url: URL?
//    private var webView: WKWebView?
//
//    func load(_ request: URLRequest) {
//        url = request.url
//        webView?.load(request)
//    }
//    
//    func setWebView(_ webView: WKWebView) {
//        self.webView = webView
//        if let url = url {
//            webView.load(URLRequest(url: url))
//        }
//    }
//}
//
///// SwiftUI view wrapping WKWebView and binding to a WebPage model.
//struct WebView: UIViewRepresentable {
//    @ObservedObject var page: WebPage
//
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        page.setWebView(webView)
//        if let url = page.url {
//            webView.load(URLRequest(url: url))
//        }
//        return webView
//    }
//    
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        // Nothing needed here; loading is handled via WebPage
//    }
//}
