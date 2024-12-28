//
//  Predators.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 11/14/24.
//

import Foundation

/// An enum representing potential errors that can occur during the JSON decoding process for predators.
enum JSONDecodeError: Error {
    case fileNotFound
    case decodingFailed(Error)
}

/// A class responsible for loading and filtering the list of predators.
class Predators {
    /// The list of all apex predators as loaded from the JSON file.
    private var allApexPredators: [ApexPredator] = []
    
    init() {
        do {
            try loadPredators()
        } catch {
            print("Error loading predators: \(error)")
        }
    }
    
    /// Loads predators data from a JSON file in the app bundle.
    ///
    /// - Throws: `JSONDecodeError.fileNotFound` if the file cannot be located.
    ///           `JSONDecodeError.decodingFailed` if the decoding process fails.
    private func loadPredators() throws {
        guard let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: "json") else {
            throw JSONDecodeError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            allApexPredators = try decoder.decode([ApexPredator].self, from: data)
            //            apexPredators = allApexPredators
        } catch {
            throw JSONDecodeError.decodingFailed(error)
        }
    }
    
    /// Filters the predators list by their type (e.g., land, air, sea, all).
    ///
    /// - Parameter type: The type of predator to filter by.
    /// - Returns: A list of predators that match the specified type.
    func filter(by type: PredatorType) -> [ApexPredator] {
        return type == .all ? allApexPredators :allApexPredators.filter { $0.type == type }
    }
}
