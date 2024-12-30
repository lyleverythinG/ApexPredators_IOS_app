//
//  PredatorMap.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 11/24/24.
//

import SwiftUI
import MapKit

struct PredatorMap: View {
    @StateObject private var vm = PredatorsViewModel()
    @State var position: MapCameraPosition
    @State var satellite = false
    @State private var selectedPredator: ApexPredator?
    
    var body: some View {
        Map(position: $position) {
            ForEach(vm.filteredPredators) { predator in
                Annotation(predator.name, coordinate: predator.location) {
                    PredatorMapAnnotationView(predator: predator, isSelected: selectedPredator == predator, onTap: { selectedPredator = predator },
                                              onClose: { selectedPredator = nil } )
                }
            }
        }
        .mapStyle(satellite ? .imagery(elevation: .realistic) : .standard(elevation: .realistic))
        .overlay(alignment: .bottomTrailing) {
            ToggleMapView(satellite: $satellite)
        }
        .preferredColorScheme(.dark)
        .toolbarBackground(.automatic)
    }
    
    private struct PredatorMapAnnotationView: View {
        let predator: ApexPredator
        let isSelected: Bool
        let onTap: () -> Void
        let onClose: () -> Void
        
        var body: some View {
            ZStack {
                // Predator Image
                ReusableScaledToFitImg(predatorImg: predator.image)
                    .frame(height: 100)
                    .shadow(color: .white, radius: 3)
                    .scaleEffect(x: -1)
                
                // Info Card
                if isSelected {
                    PredatorInfoCard(predator: predator, onClose: onClose)
                        .frame(maxWidth: 340)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .offset(y: 150)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isSelected)
                }
            }
            .onTapGesture {
                onTap()
            }
        }
    }
    
    private struct PredatorInfoCard: View {
        let predator: ApexPredator
        let onClose: () -> Void
        
        @State private var humanReadableLocation: String = ""
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    // Predator name
                    APText.title2(predator.name)
                    
                    Spacer()
                    
                    // Close button
                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .imageScale(.large)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                }
                
                // Location
                APText.defaultText("Location: \(humanReadableLocation)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                // Predator type
                HStack {
                    APText.subHeadline("Type:")
                    APText.subHeadline(predator.type.rawValue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(predator.type.background)
                        .clipShape(.capsule)
                }
                
                // Appears in
                APText.subHeadline("Appears in:")
                
                ForEach(predator.movies, id: \.self) { movie in
                    APText.subHeadline("• " + movie)
                }
                
                
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 5)
            .padding(.horizontal, 10)
            .onAppear {
                LocationService.fetchHumanReadableLocation(latitude: predator.latitude, longitude: predator.longitude) { location in
                    humanReadableLocation = location
                }
            }
        }
    }
    
    private struct ToggleMapView: View {
        @Binding var satellite: Bool
        
        var body: some View {
            Button {
                satellite.toggle()
            } label: {
                Image(systemName: satellite ? "globe.americas.fill" : "globe.americas")
                    .font(.largeTitle)
                    .imageScale(.large)
                    .background(.clear)
                    .padding()
            }
        }
    }
}
