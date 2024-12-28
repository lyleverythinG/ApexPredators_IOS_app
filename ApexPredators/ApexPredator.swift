//
//  ApexPredator.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 11/14/24.
//

import Foundation
import SwiftUI
import MapKit

/// Represents an apex predator with properties such as id, name, type, latitude, longitude, movies, movieScenes, and link.
struct ApexPredator : Decodable, Identifiable {
    let id: Int
    let name: String
    let type: PredatorType
    let latitude: Double
    let longitude: Double
    let movies: [String]
    let movieScenes: [MovieScene]
    let link: String
    
    /// Computed property for the predator's image name based on its name.
    var image: String {
        name.lowercased().replacingOccurrences(of: " ", with: "")
    }
    
    /// Computed property for the predator's geographic location.
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Represents a specific scene in a movie.
    struct MovieScene : Decodable, Identifiable {
        let id: Int
        let movie: String
        let sceneDescription: String
    }
}

/// Enum representing the different types of predators (land, air, sea, or all).
/// Each type has associated properties, including a background color and an SF Symbol icon for UI representation.
enum PredatorType: String, Decodable, CaseIterable, Identifiable {
    var id: PredatorType {
        self
    }
    case all
    case land
    case air
    case sea
    
    /// Background color associated with the predator type.
    var background: Color {
        switch self {
        case .land:
                .brown
        case .air:
                .teal
        case .sea:
                .blue
        case .all:
                .black
        }
    }
    
    /// SF Symbol icon representing the predator type.
    var icon: String {
        switch self {
        case .all:
            "square.stack.3d.up.fill"
        case .land:
            "leaf.fill"
        case .air:
            "wind"
        case .sea:
            "drop.fill"
        }
    }
}
