//
//  Predators.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 11/14/24.
//

import Foundation

enum JSONDecodeError: Error {
    case fileNotFound
    case decodingFailed(Error)
}

class Predators {
    private var allApexPredators: [ApexPredator] = []
    private(set) var apexPredators: [ApexPredator] = []
    init() {
        do {
            try loadPredators()
        } catch {
            print("Error loading predators: \(error)")
        }
    }
    
    private func loadPredators() throws {
        guard let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: "json") else {
            throw JSONDecodeError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            allApexPredators = try decoder.decode([ApexPredator].self, from: data)
            apexPredators = allApexPredators
        } catch {
            throw JSONDecodeError.decodingFailed(error)
        }
    }
    
    func search(for searchText: String) -> [ApexPredator] {
        return searchText.isEmpty ? apexPredators : apexPredators.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    func sort(by alphabetical: Bool) -> [ApexPredator] {
        return apexPredators.sorted {
            alphabetical ? $0.name < $1.name : $0.id < $1.id
        }
    }
    
    func filter(by type: PredatorType) -> [ApexPredator] {
        return type == .all ? allApexPredators :allApexPredators.filter { $0.type == type }
    }
}
