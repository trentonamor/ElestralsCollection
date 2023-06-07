//
//  WebView.swift
//  ElestralsCollection
//
//  Created by Trenton Parrotte on 12/9/22.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    let requestURLString: String
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: requestURLString) {
           let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

//struct WebView_Previews: PreviewProvider {
//    static var previews: some View {
//        WebView()
//    }
//}
