//
//  APText.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 12/28/24.
//

import SwiftUI

struct APText {
    static func defaultText(_ text: String) -> some View {
        Text(text)
    }
    
    static func largeTitle(_ text: String) -> some View {
        Text(text)
            .font(.largeTitle)
    }
    
    static func title(_ text: String) -> some View {
        Text(text)
            .font(.title)
    }
    
    static func title2(_ text: String) -> some View {
        Text(text)
            .font(.title2)
    }
    
    static func title3(_ text: String) -> some View {
        Text(text)
            .font(.title3)
    }
    
    static func subHeadline(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
    }
    
    static func caption(_ text: String) -> some View {
        Text(text)
            .font(.caption)
    }
}
