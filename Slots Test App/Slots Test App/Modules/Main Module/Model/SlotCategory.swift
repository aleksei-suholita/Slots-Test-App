import Foundation

enum SlotCategory: CaseIterable {
    
    case popular, allGames
    
    var name: String {
        switch self {
        case .popular:
            return "Popular"
        case .allGames:
            return "All Games"
        }
    }
    
    var slots: [SlotType] {
        switch self {
        case .popular:
            return SlotType.allCases.filter { $0.isPopular }
        case .allGames:
            return SlotType.allCases
        }
    }
    
}
