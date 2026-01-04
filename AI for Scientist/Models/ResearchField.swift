//
//  ResearchField.swift
//  AI for Scientist
//
//  Model representing different research fields/domains
//  Used for filtering and categorizing scientific literature
//

import Foundation

/// Represents a scientific research field or domain
struct ResearchField: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let keywords: [String]

    init(id: UUID = UUID(), name: String, description: String, keywords: [String]) {
        self.id = id
        self.name = name
        self.description = description
        self.keywords = keywords
    }
}

// MARK: - Predefined Research Fields
extension ResearchField {
    /// Common research fields for quick selection
    static let predefinedFields: [ResearchField] = [
        ResearchField(
            name: "Artificial Intelligence",
            description: "Machine learning, deep learning, neural networks, and AI applications",
            keywords: ["AI", "machine learning", "deep learning", "neural networks", "NLP", "computer vision"]
        ),
        ResearchField(
            name: "Physics",
            description: "Theoretical and experimental physics, quantum mechanics, astrophysics",
            keywords: ["physics", "quantum", "mechanics", "astrophysics", "particle physics"]
        ),
        ResearchField(
            name: "Biology",
            description: "Molecular biology, genetics, biochemistry, and life sciences",
            keywords: ["biology", "genetics", "molecular", "biochemistry", "genomics"]
        ),
        ResearchField(
            name: "Computer Science",
            description: "Algorithms, systems, software engineering, and theoretical CS",
            keywords: ["computer science", "algorithms", "programming", "software", "systems"]
        ),
        ResearchField(
            name: "Mathematics",
            description: "Pure and applied mathematics, statistics, and mathematical modeling",
            keywords: ["mathematics", "statistics", "algebra", "calculus", "topology"]
        ),
        ResearchField(
            name: "Chemistry",
            description: "Organic, inorganic, physical, and analytical chemistry",
            keywords: ["chemistry", "organic", "inorganic", "catalysis", "synthesis"]
        ),
        ResearchField(
            name: "Neuroscience",
            description: "Brain science, cognitive neuroscience, and neuroimaging",
            keywords: ["neuroscience", "brain", "cognitive", "neuroimaging", "neural"]
        ),
        ResearchField(
            name: "Materials Science",
            description: "Material properties, nanotechnology, and material design",
            keywords: ["materials", "nanotechnology", "polymers", "composites", "crystals"]
        )
    ]
}
