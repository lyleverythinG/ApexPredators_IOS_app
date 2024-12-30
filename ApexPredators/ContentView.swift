//
//  ContentView.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 11/14/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var vm = PredatorsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.filteredPredators) { predator in
                    NavigationLink {
                        PredatorDetail(predator: predator,
                                       position: .camera(MapCamera(centerCoordinate: predator.location, distance: 30000)))
                    } label: {
                        HStack {
                            // Dinosaur Image
                            ReusableScaledToFitImg(predatorImg: predator.image)
                                .frame(width: 100, height: 100)
                                .shadow(color: .white, radius: 1)
                            
                            VStack(alignment: .leading) {
                                // Name
                                APText.defaultText(predator.name)
                                    .fontWeight(.bold)
                                
                                // Type
                                APText.subHeadline(predator.type.rawValue.capitalized)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 13)
                                    .padding(.vertical, 5)
                                    .background(predator.type.background)
                                    .clipShape(.capsule)
                            }
                        }
                    }
                }
                .onDelete(perform: vm.handleDeletionOfPredator)
            }
            .navigationTitle("Apex Predators")
            .searchable(text: $vm.searchText)
            .autocorrectionDisabled()
            .animation(.default, value: vm.searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    toggleAlphabeticalButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    filterMenu
                }
            }
        }
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
    
    /// A computed property that provides a button to toggle between alphabetical and default sorting.
    private var toggleAlphabeticalButton: some View {
        Button {
            withAnimation {
                vm.isAlphabetical.toggle()
            }
        } label: {
            Image(systemName: vm.isAlphabetical ? "film" : "textformat")
                .symbolEffect(.bounce, value: vm.isAlphabetical)
        }
    }
    
    /// A computed property that provides a menu for filtering predators by their type.
    private var filterMenu: some View {
        Menu {
            Picker("Filter", selection: $vm.currentSelection.animation()) {
                ForEach(PredatorType.allCases) { type in
                    Label(type.rawValue.capitalized, systemImage: type.icon)
                }
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }
}

#Preview {
    ContentView()
}
