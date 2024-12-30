//
//  PredatorDetail.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 11/22/24.
//

import SwiftUI
import MapKit

struct PredatorDetail: View {
    let predator: ApexPredator
    @State var position: MapCameraPosition
    
    var body: some View {
            NavigationLink {
                FullScreenPredatorView(predator: predator)
            } label: {
                GeometryReader { geo in
                    ScrollView {
                            // Background Img
                            BackgroundDetailImg(geo:geo, predator: predator)
                            
                            VStack(alignment: .leading) {
                                // Dino Name
                                APText.largeTitle(predator.name)
                                
                                // Current Location / Mini-map Section
                                MapSection(geo: geo, predator: predator, position: $position)
                                
                                // Appears in Section
                                APText.title3("Appears In:")
                                    .padding(.top)
                                ForEach(predator.movies, id: \.self) { movie in
                                    APText.subHeadline("• " + movie)
                                }
                                
                                // Movie Moments Section
                                APText.title("Movie Moments")
                                    .padding(.top, 15)
                                
                                // Title and description of movies
                                ForEach(predator.movieScenes) { scene in
                                    APText.title2(scene.movie)
                                        .padding(.vertical, 1)
                                    APText.defaultText(scene.sceneDescription)
                                        .padding(.bottom, 15)
                                }
                                
                                // Read More Link
                                if let url = URL(string: predator.link), !predator.link.isEmpty {
                                    APText.caption("Read More:")
                                    HStack {
                                        Link (predator.link, destination: url)
                                            .foregroundStyle(.blue)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.bottom, 10)
                                }
                            }
                            .padding()
                            .frame(width:geo.size.width,alignment: .leading)
                    }
                    .ignoresSafeArea()
                }
                .toolbarBackground(.automatic)
            }
    }
    
    private struct FullScreenPredatorView: View {
        let predator: ApexPredator
        
        var body: some View {
            ZStack {
                Image(predator.type.rawValue)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0)
                    .edgesIgnoringSafeArea(.all)
                
                Image(predator.image)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(x: -1)
                    .shadow(color: .black,radius: 7)
                    .padding(10)
            }
        }
    }
    
    private struct BackgroundDetailImg: View {
        let geo: GeometryProxy
        let predator: ApexPredator
        
        var body: some View {
            ZStack(alignment: .bottomTrailing)  {
                // Background Image
                ReusableScaledToFitImg(predatorImg: predator.type.rawValue)
                    .overlay {
                        LinearGradient (stops: [
                            Gradient.Stop(color: .clear, location:0.8),
                            Gradient.Stop(color: .black, location:1)
                        ], startPoint: .top, endPoint: .bottom)
                    }
                
                // Dino Image
                ReusableScaledToFitImg(predatorImg: predator.image)
                    .frame(width:geo.size.width/1.5,height:geo.size.height/3)
                    .scaleEffect(x:-1)
                    .shadow(color: .black,radius: 7)
                    .offset(y:20)
            }
        }
    }
    
    private struct MapSection: View {
        let geo: GeometryProxy
        let predator: ApexPredator
        @Binding var position: MapCameraPosition
        
        var body: some View {
            NavigationLink {
                PredatorMap(position: .camera(MapCamera(centerCoordinate: predator.location,
                                                        distance: 1000,
                                                        heading: 250,
                                                        pitch: 80)))
            } label: {
                Map(position: $position) {
                    Annotation(predator.name, coordinate: predator.location) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.largeTitle)
                            .imageScale(.large)
                            .symbolEffect(.pulse)
                    }
                    .annotationTitles(.hidden)
                }
                .frame(height: 125)
                .overlay(alignment:.trailing) {
                    Image(systemName: "greaterthan")
                        .imageScale(.large)
                        .font(.title3)
                        .padding(.trailing, 5)
                }
                .overlay(alignment: .topLeading) {
                    APText.defaultText("Current Location")
                        .padding([.leading, .bottom], 5)
                        .padding(.trailing, 8)
                        .background(.black.opacity(0.33))
                        .clipShape(.rect(bottomTrailingRadius: 15))
                }
                .clipShape(.rect(cornerRadius: 15))
            }
        }
    }
}
