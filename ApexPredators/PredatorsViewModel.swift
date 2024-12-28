//
//  PredatorsViewModel.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 12/28/24.
//

import Foundation
import Combine

/// ViewModel for managing and updating the list of predators based on user inputs.
/// Handles filtering, sorting, and searching operations, and updates the UI reactively.
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
    
    /// Handles changes to the search text, sorting preference (alphabetical or not), filter type,
    /// and  updates the filteredPredators list accordingly.
    private func handleChanges(searchText: String, isAlphabetical: Bool, type: PredatorType) {
        updateFilteredPredators(searchText: searchText, isAlphabetical: isAlphabetical, type: type)
    }
    
    /// Applies filtering, sorting, and searching to the predators list based on the current state.
    ///
    /// - Parameters:
    ///   - searchText: The search query to filter the predators by name.
    ///   - isAlphabetical: Whether the list should be sorted alphabetically.
    ///   - type: The selected predator type to filter the list. Options are:
    ///       - `.all`: Includes all predator types.
    ///       - `.land`: Filters for land-based predators.
    ///       - `.air`: Filters for air-based predators.
    ///       - `.sea`: Filters for sea-based predators.
    private func updateFilteredPredators(searchText: String, isAlphabetical: Bool, type: PredatorType) {
        // Filter and sort based on the current state
        let filtered = predatorsModel.filter(by: type)
        let sorted = isAlphabetical ? filtered.sorted { $0.name < $1.name } : filtered
        
        filteredPredators = searchText.isEmpty ? sorted : sorted.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}
