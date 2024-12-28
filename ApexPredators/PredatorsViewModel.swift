//
//  PredatorsViewModel.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 12/28/24.
//

import Foundation
import Combine

final class PredatorsViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isAlphabetical: Bool = false
    @Published var currentSelection: PredatorType = .all
    @Published private(set) var filteredPredators: [ApexPredator] = []
    
    private let predatorsModel = Predators()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Update filteredPredators whenever searchText, isAlphabetical, or currentSelection changes.
        Publishers.CombineLatest3($searchText, $isAlphabetical, $currentSelection)
            .sink { [weak self] in
                self?.handleChanges(searchText: $0, isAlphabetical: $1, type: $2)
            }
            .store(in: &cancellables)
    }
    
    private func handleChanges(searchText: String, isAlphabetical: Bool, type: PredatorType) {
        updateFilteredPredators(searchText: searchText, isAlphabetical: isAlphabetical, type: type)
    }
    
    private func updateFilteredPredators(searchText: String, isAlphabetical: Bool, type: PredatorType) {
        // Filter and sort based on the current state
        let filtered = predatorsModel.filter(by: type)
        let sorted = isAlphabetical ? filtered.sorted { $0.name < $1.name } : filtered
        let searched = searchText.isEmpty ? sorted : sorted.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        
        filteredPredators = searched
    }
}
