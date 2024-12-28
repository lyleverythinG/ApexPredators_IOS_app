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
            List(vm.filteredPredators) { predator in
                NavigationLink {
                    PredatorDetail(predator: predator,
                                   position: .camera(MapCamera(centerCoordinate: predator.location, distance: 30000)))
                } label: {
                    HStack {
                        //Dinosaur Image
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100,height:100)
                            .shadow(color: .white , radius: 1)
                        
                        VStack(alignment: .leading) {
                            // Name
                            Text(predator.name)
                                .fontWeight(.bold)
                            
                            // Type
                            Text(predator.type.rawValue.capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 13)
                                .padding(.vertical, 5)
                                .background(predator.type.background)
                                .clipShape(.capsule)
                        }
                    }
                }
            }
            .navigationTitle("Apex Predators")
            .searchable(text: $vm.searchText)
            .autocorrectionDisabled()
            .animation(.default, value: vm.searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            vm.isAlphabetical.toggle()
                        }
                    } label:  {
                        Image(systemName: vm.isAlphabetical ? "film" : "textformat")
                            .symbolEffect(.bounce, value: vm.isAlphabetical)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Filter",selection: $vm.currentSelection.animation()) {
                            ForEach(PredatorType.allCases) { type in
                                Label(type.rawValue.capitalized,
                                      systemImage:type.icon
                                )
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
}
