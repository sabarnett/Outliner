//
// File: HtmlView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 01/02/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import WebKit
import SwiftUI

struct HTMLView: NSViewRepresentable {
    let htmlContent: String

    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateNSView(_ uiView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            uiView.loadHTMLString(htmlContent, baseURL: nil)
        }
    }
}
