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
                    .overlay {
                        LinearGradient (stops: [
                            Gradient.Stop(color: .clear, location:0.8),
                            Gradient.Stop(color: .black, location:1)
                        ], startPoint: .top, endPoint: .bottom)
                    }
                
                // Dino Image
                Image(predator.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:geo.size.width/1.5,height:geo.size.height/3)
                    .scaleEffect(x:-1)
                    .shadow(color: .black,radius: 7)
                    .offset(y:20)
            }
            VStack(alignment: .leading) {
                // Dino Name
                Text(predator.name)
                    .font(.largeTitle)
                // TODO: Handle current location later.
                // Current Location
                
                // Appears in
                Text("Appears In:")
                    .font(.title3)
                
                ForEach(predator.movies, id: \.self) { movie in
                    Text("• " + movie)
                        .font(.subheadline)
    
                }
                // Movie moments Text
                Text("Movie Moments")
                    .font(.title)
                    .padding(.top, 15)
    
                // Title and description of movies
                ForEach(predator.movieScenes) { scene in
                    Text(scene.movie)
                        .font(.title2)
                        .padding(.vertical, 1)
                    
                    Text(scene.sceneDescription)
                        .padding(.bottom, 15)
                }
                
                // Link
                // TODO: Avoid this force unwrapping behavior. Follow the course then improve code quality once finish.
                Text("Read More:")
                    .font(.caption)
                Link (predator.link, destination: URL(string:predator.link)!)
            }
            .padding()
            .frame(width:geo.size.width,alignment: .leading)
        }
        .ignoresSafeArea()
    }
    }
}

#Preview {
    PredatorDetail(predator:Predators().apexPredators[2])
    .preferredColorScheme(.dark)
}
