//
//  PredatorDetail.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 11/22/24.
//

import SwiftUI

struct PredatorDetail: View {
    let predator: ApexPredator
    var body: some View {
               GeometryReader { geo in
        ScrollView {
            ZStack(alignment: .bottomTrailing)  {
                // Background Image
                Image(predator.type.rawValue)
                    .resizable()
                    .scaledToFit()
                
                // Dino Image
                Image(predator.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:geo.size.width/1.5,height:geo.size.height/3)
                    .scaleEffect(x:-1)
                    .shadow(color: .black,radius: 7)
                    .offset(y:20)
            }
            
            // Dino Name
            
            // Current Location
            
            // Appears in
            
            // Movie moments
            
            // Link
        }
        .ignoresSafeArea()
    }
    }
}

#Preview {
    PredatorDetail(predator:Predators().apexPredators[2])
    // .preferredColorScheme(.dark)
}
