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
    private var deletedPredators: Set<Int> = []
    
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
    
    /// Deletes a predator from the `filteredPredators` list and tracks the deletion.
    ///
    /// - This function removes the specified predator(s) from the `filteredPredators` array based on the provided `IndexSet` of offsets.
    /// - The ID of each deleted predator is stored in the `deletedPredators` set, which helps track the deleted items without modifying the original predator list.
    /// - The purpose of tracking deleted predators in the `deletedPredators` set is to ensure they do not reappear when the list is filtered or sorted again.
    ///
    /// - Parameters:
    ///   - offsets: A set of indices representing the positions of the predators to be deleted from the `filteredPredators` list.
    ///
    /// - Note: This function only affects the `filteredPredators` list and ensures that the deletion is consistent across updates like sorting or filtering.
    func handleDeletionOfPredator(at offsets: IndexSet) {
        for index in offsets {
            let predator = filteredPredators[index]
            deletedPredators.insert(predator.id)
        }
        
        // Removes the selected predator based from its offsets.
        filteredPredators.remove(atOffsets: offsets)
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
        var filteredList = predatorsModel.allApexPredators
        
        // Apply filter by type
        if type != .all {
            filteredList = filteredList.filter { $0.type == type }
        }
        
        // Apply search filtering
        if !searchText.isEmpty {
            filteredList = filteredList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        // Exclude deleted predators
        filteredList = filteredList.filter { !deletedPredators.contains($0.id) }
        
        // Apply sorting if necessary
        if isAlphabetical {
            filteredList.sort { $0.name.lowercased() < $1.name.lowercased() }
        }
        
        // Update the filteredPredators list
        filteredPredators = filteredList
    }
}
