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
    
    var body: some View {
        Map(position: $position) {
            ForEach(vm.filteredPredators) { predator in
                Annotation(predator.name, coordinate: predator.location) {
                    ReusableScaledToFitImg(predatorImg: predator.image)
                        .frame(height: 100)
                        .shadow(color: .white, radius: 3)
                        .scaleEffect(x: -1)
                }
            }
        }
        .mapStyle(satellite ? .imagery(elevation: .realistic) : .standard( elevation: .realistic))
        .overlay(alignment: .bottomTrailing) {
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
        .toolbarBackground(.automatic)
    }
}
