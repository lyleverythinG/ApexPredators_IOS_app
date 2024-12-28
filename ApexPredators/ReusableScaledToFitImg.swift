//
//  ReusableImage.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 12/28/24.
//

import SwiftUI

struct ReusableScaledToFitImg: View {
    let predatorImg: String
    
    var body: some View {
        Image(predatorImg)
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    ReusableScaledToFitImg(predatorImg: "indoraptor")
}
