//
//  ApexPredator.swift
//  ApexPredators
//
//  Created by Lyle Dane Carcedo on 11/14/24.
//

import Foundation
import SwiftUI

struct ApexPredator : Decodable, Identifiable {
    let id: Int
    let name: String
    let type: PredatorType
    let latitude: Double
    let longitude: Double
    let movies: [String]
    let movieScenes: [MovieScene]
    let link: String
    
    var image: String {
        name.lowercased().replacingOccurrences(of: " ", with: "")
    }
    
    struct MovieScene : Decodable {
        let id: Int
        let movie: String
        let sceneDescription: String
    }
}

enum PredatorType: String, Decodable, CaseIterable, Identifiable {
    var id: PredatorType {
        self
    }
    case all
    case land
    case air
    case sea
    
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
