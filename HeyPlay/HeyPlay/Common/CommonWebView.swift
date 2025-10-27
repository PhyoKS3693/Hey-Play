//
//  CommonWebView.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI
import WebKit

struct CommonWebView: UIViewRepresentable {
    enum Source {
        case url(String)
        case localFile(String, type: String)
        case html(String)
    }
    
    let source: Source
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        switch source {
        case .url(let urlString):
            if let url = URL(string: urlString) {
                uiView.load(URLRequest(url: url))
            }
        case .localFile(let name, let type):
            if let filePath = Bundle.main.path(forResource: name, ofType: type),
               let html = try? String(contentsOfFile: filePath, encoding: .utf8) {
                uiView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
            }
        case .html(let htmlString):
            uiView.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: CommonWebView
        init(_ parent: CommonWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}
