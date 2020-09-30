//
//  Universe.swift
//  CharactersGrid
//
//  Created by Alfian Losari on 9/22/20.
//

import Foundation

enum Universe: CaseIterable {
    case ff7r
    case marvel
    case dc
    case starwars
    
    var stubs: [Character] {
        switch self {
        case .ff7r:
            return Character.ff7Stubs
        case .marvel:
            return Character.marvelStubs
        case .dc:
            return Character.dcStubs
        case .starwars:
            return Character.starWarsStubs
        }
    }
    
    var sectionedStubs: [SectionCharacters] {
        let stubs = self.stubs
        var categoryCharactersDict = [String: [Character]]()
        stubs.forEach { (character) in
            let category = character.category
            if let characters = categoryCharactersDict[category] {
                categoryCharactersDict[category] = characters + [character]
            } else {
                categoryCharactersDict[category] = [character]
            }
        }
        let sectionedStubs = categoryCharactersDict.map { (category, items) -> SectionCharacters in
            SectionCharacters(category: category, characters: items)
        }.sorted { $0.category < $1.category }
        return sectionedStubs
    }
    
    var title: String {
        switch self {
        case .ff7r:
            return "FF7R"
        case .dc:
            return "DC Comics"
        case .marvel:
            return "Marvel"
        case .starwars:
            return "Star Wars"
        }
    }
}

