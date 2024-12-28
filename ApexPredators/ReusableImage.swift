//
//  ReusableImage.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 12/28/24.
//

import SwiftUI

struct ReusableImage: View {
    let predatorImg: String
    
    var body: some View {
        Image(predatorImg)
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    ReusableImage(predatorImg: "indoraptor")
}
